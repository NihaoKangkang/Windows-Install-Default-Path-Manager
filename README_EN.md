# Windows-Install-Default-Path-Manager

ENGLISH / [中文](README.md)

A lightweight, safe, and efficient PowerShell utility to customize Windows default installation paths and manage AppData redirection.

Author: `Kyi Wong`

EMAIL: `kyiwong97@gmail.com`

## Features

- Global Path Customization: Safely redirect default `Program Files` and `Program Files (x86)` locations to a custom drive.
- Shadow Redirection: Automatically creates a "Shadow" junction point in `AppData\Local` to safely store application data on your target drive, preventing C-drive bloat.
- One-Click Restore: Easily revert all changes to Windows default system settings while preserving your data links.
- Safety First: Includes non-C-drive enforcement and clear user alerts to prevent system logic errors.

## Usage
- Download: Download the Installer_Manager.ps1 script to your desired folder.

### Prepare Environment:

- Hold the Shift key and Right-click inside the folder where the script is located.

- Select "Open PowerShell window here" (or "Open in Terminal").

- Run the following command to allow script execution:

```PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Run: Now you can run the script:

```PowerShell
.\Installer_Manager.ps1
```

If prompted, click "Yes" to grant Administrator privileges when the UAC window appears.

## How it works

The tool modifies core Windows Registry keys (`ProgramFilesDir`, `ProgramW6432Dir`) and creates NTFS Junctions to redirect data flow without breaking system dependencies.

## Disclaimer

This tool modifies registry keys (`HKLM`). While it includes safety checks, please ensure you have backups of critical data. Use at your own risk.

## License

This project is licensed under the MIT License.
