# CamoOS

[![](https://img.shields.io/github/downloads/CamoOS/CamoOS/total)](https://github.com/CamoOS/CamoOS/releases/latest)
[![Build Release](https://github.com/CamoOS/CamoOS/actions/workflows/release.yml/badge.svg)](https://github.com/CamoOS/CamoOS/actions/workflows/release.yml)
[![](https://shields.io/discord/1066751620794298378)](https://discord.gg/jdbzsYSTVJ)

## â What CamoOS is

- đ¸ A free operating system based on Mini11
- đ A private operating system
- đ A secure operating system

## đĢ What CamoOS is not

- đŽ An ISO to improve performance for gaming, such as RekOS
- đž A program that helps with privacy, such as O&O ShutUp
- đ A privacy-first ISO, such as AME. CamoOS is designed for security as well.

## âšī¸ What's not supported in CamoOS?

Everything that O&O ShutUp's not recommended level blocks/removes (except for some security-related options), as well as everything Mini11 (if you built it yourself) or Slim11 (if you downloaded from the CI) removes.

## â How do I create a CamoOS ISO?

1. Firstly, copy a [Mini11 22H2 ISO](https://archive.org/download/mini11-22h2/Mini11%2022H2%20Beta%201%20Whistler.iso) to DVD.iso
1. You will also need to make sure that your execution policy is Bypass or Unrestricted.
1. Open a PowerShell window as admin.
1. Hold Shift and right click build.ps1. Then click Copy as path.
1. Then type `. <paste path>`, where with `<paste path>` you right click PowerShell to paste
1. Press Enter to run.
1. It will perform it's necessary checks, and will produce an ISO along with a SHA1 checksum.

## đ¨âđģ How do I install CamoOS?

It is as similar as installing regular Windows. However, avoid Easy Install or similar in your virtualization software, it will cause unsane defaults that reduce privacy.

## đ How do I activate CamoOS?

CamoOS comes activated out of the box, with MAS.

## đ¤ FAQ

<details>
<summary>My ISO contains the Store. Why?</summary>
The Store isn't removed because with ShutUp10, it's not a big privacy concern anyway. And also some privacy tools are also available there (like the Diagnostic Data Viewer)
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

## â¤ī¸ Special Thanks to

- **O&O** for the privacy enhancements
- **Kowan011** for Mini11/Slim11
- **Mozilla** for a decent browser to ship, LibreWolf is almost impossible
- **WindowsAddict** for making a dead simple activator we can integrate easily
