# CamoOS

## 🟩 What CamoOS is

CamoOS is a free, private, and secure operating system built upon Windows LTSC.

## 🟥 What CamoOS is not

- An ISO to improve performance for gaming, such as FoxOS
- A program that helps with privacy, such as O&O ShutUp
- A privacy-first ISO, such as AME. CamoOS is designed for security as well.

## 🟪 What's not supported in CamoOS?

Everything that O&O ShutUp's not recommended level blocks/removes (except for some security-related options), which can easily be restored as needed.

## 🟦 How do I create a CamoOS ISO?

1. Firstly, copy an LTSC 2021+ ISO **(IoT will not work, 32-bit not recommended and untested, the former will have no support, older versions may work, but untested and will have no support)**, to a file called DVD.iso next to the build script.
1. You will also need to make sure that your execution policy is Bypass or Unrestricted.
1. Open a PowerShell window as admin.
1. Hold Shift and right click build.ps1. Then click Copy as path.
1. Then type `. <paste path>`, where with `<paste path>` you right click PowerShell to paste
1. Press Enter to run.
1. It will perform it's necessary checks, and will produce an ISO along with a SHA1 checksum.

## 🟨 How do I install CamoOS?

It is as similar as installing regular Windows.

## 🟥 How do I activate CamoOS?

CamoOS comes activated out of the box, with MAS.

## 🟦 FAQ

<details>
<summary>There is a broken Edge application in the Start menu. Is this normal?</summary>
This is perfectly normal, UninstallAllEdgeChromium doesn't do a good job a lot of times.
</details>
<details>
<summary>My ISO contains OneDrive. Why?</summary>
OneDrive is not removed because depending on the user's threat model, it might be useful. You can uninstall it if you wish, though some ISOs won't contain it.
</details>
<details>
<summary>Building failed!</summary>
This is usually because you used a 2016- image, or an IoT image. You can fix this by renaming the index to <code>Windows 10 Enterprise LTSC</code>, but it will be untested, and as such, no support. It is recommended to use the latest stable build provided in the releases page.
</details>
<details>
<summary>My checksums don't match!</summary>
If you haven't synced the checksum file along with the ISO, the checksums won't match since every ISO created will be unique. This is a technical limitation of the tools that the build script uses. Otherwise, the ISO may have been tampered with or corrupted.
</details>
<!--
<details>
<summary></summary>
</details>
-->
