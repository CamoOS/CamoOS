Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)

if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

if (!($env:CI -eq "true")) {
    if (!(Test-Connection github.com -Quiet -Count 2)) {
        Write-Host "Please connect to the Internet."
        Exit
    }
}

if (!(Test-Path "DVD.iso")) {
    Write-Host "Copy a Mini11 22H2 ISO to 'DVD.iso'. Tested with Beta 1. Other builds may not get updates."
    Exit
}

$currentDate = Get-Date -Format "yy-MM-dd"

if (Test-Path "DVD") {
    Write-Host "Deleting DVD folder"
    Remove-Item DVD -Recurse -Force
}

Write-Host "Extracting ISO"

.\7z.exe x DVD.iso -oDVD

Write-Host "Downloading Firefox and MAS"

Start-BitsTransfer -Source "https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win&lang=en-US" -Destination "`$OEM$\`$$\Setup\Scripts\Firefox.msi" -Description "Downloading Firefox"
Start-BitsTransfer -Source "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version/MAS_AIO.cmd" -Destination "`$OEM$\`$$\Setup\Scripts\MAS_AIO.cmd" -Description "Downloading MAS"

if (Test-Path .\cache.wim) {
    Remove-Item .\DVD\sources\install.esd -Force
    Copy-Item .\cache.wim .\DVD\sources\install.wim -Force
}

if (Test-Path .\DVD\sources\install.esd) {
    Write-Host "Converting ESD to WIM"
    Export-WindowsImage -SourceImagePath .\DVD\sources\install.esd -SourceIndex 1 -DestinationImagePath .\DVD\sources\install.wim -CompressionType fast
    Remove-Item .\DVD\sources\install.esd -Force
    if (!($env:CI -eq "true")) {
        Write-Host "Building WIM cache"
        Copy-Item .\DVD\sources\install.wim .\cache.wim -Force
    }
}

Write-Host "Mounting image"

mkdir mount
Mount-WindowsImage -ImagePath .\DVD\sources\install.wim -Index 1 -Path mount

Write-Host "Loading hives"

reg load HKEY_USERS\ODU mount\users\default\ntuser.dat
reg load HKEY_LOCAL_MACHINE\SOFT mount\windows\system32\config\software

Write-Host "Applying tweaks"

reg import tweaks.reg

Write-Host "Adding Wallpaper"

takeown /f .\mount\Windows\Web /r /d y | Out-Null
icacls .\mount\Windows\Web /grant administrators:f /t | Out-Null
Get-ChildItem -Path .\mount\Windows\Web -Filter "*.jpg" -Recurse | ForEach-Object { Copy-Item .\img0.jpg $_.FullName -Force }

Write-Host "Adding RunOnce"

$startupFolder = "mount\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup"

if (!(Test-Path $startupFolder)) {
    mkdir $startupFolder
}

Copy-Item .\RunOnce.cmd $startupFolder

Write-Host "Adding ShutUp10 to the desktop"

Copy-Item '.\$OEM$\$$\Setup\Scripts\OOSU10.exe' "mount\Users\Public\Desktop\ShutUp10.exe"

Write-Host Unloading hives

reg unload HKEY_USERS\ODU
reg unload HKEY_LOCAL_MACHINE\SOFT

if ($env:CI -eq "true") {
    Write-Host Delete compact
    Remove-Item .\mount\Windows\System32\compact.exe -Force
}

Write-Host Unmounting image

Dismount-WindowsImage -Path mount -Save

if ($env:CI -eq "true") {
    Write-Host "Converting WIM to ESD"
    Export-WindowsImage -SourceImagePath .\DVD\sources\install.wim -SourceIndex 1 -DestinationImagePath .\DVD\sources\install.esd -CompressionType max
    Remove-Item .\DVD\sources\install.wim -Force
}

Remove-Item mount -Force

Write-Host Copying OEM folder

robocopy "`$OEM$" "DVD\sources\`$OEM$" /e

Write-Host Copying autounattend files

Copy-Item autounattend.xml DVD -Force

Write-Host Creating ISO

$isoName = "CamoOS_built_$currentDate.iso"

cmd.exe /c "oscdimg.exe -h -m -o -u2 -udfver102 -bootdata:2#p0,e,bDVD\boot\etfsboot.com#pEF,e,bDVD\efi\microsoft\boot\efisys.bin -lCamoOS DVD $isoName"

if (Test-Path $isoName) {
    $hash = (Get-FileHash $isoName -Algorithm SHA1).Hash.ToLower()
    Write-Host "Checksum is $hash (SHA1)."
    Set-Content -Path ($isoName + ".sha1") -Value $hash -Encoding Ascii
    Write-Host "Saved checksum."
}
