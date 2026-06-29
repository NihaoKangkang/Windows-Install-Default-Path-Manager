# Windows-Install-Default-Path-Manager

[ENGLISH](README_EN.md) / 中文

这是一个轻量级、安全且高效的 PowerShell 工具，旨在自定义 Windows 的默认安装路径并管理 AppData 目录重定向。

作者: `Kyi Wong`

邮箱: `kyiwong97@gmail.com`

## 功能特性

  * 全局路径自定义：将默认的 `Program Files` 和 `Program Files (x86)` 安全重定向至指定的驱动器。
  * Shadow 重定向：自动在 `AppData\Local` 中创建 Shadow 联接，将应用数据存储至目标盘，有效避免 C 盘空间爆满。
  * 一键还原：轻松将所有更改恢复至 Windows 默认设置，同时保留数据联接以确保程序运行安全。
  * 安全优先：强制防错机制（严禁设为 C 盘），并带有明确的操作提示，确保系统逻辑安全。

## 使用方法

- 下载: 将 Installer_Manager.ps1 脚本下载到你指定的文件夹中。

### 准备运行环境:

- 在脚本所在的文件夹中，按住 Shift 键的同时右键单击空白处。

- 选择 “在此处打开 PowerShell 窗口”（或“在终端中打开”）。

- 输入并执行以下命令以允许脚本运行：

```PowerShell
powershell -ep bypass
```

### 运行: 现在你可以运行脚本了：

```PowerShell
.\Installer_Manager.ps1
```

如果弹出用户账户控制 (UAC) 窗口，请点击 “是” 以授予管理员权限。

## 原理说明

该工具通过修改核心注册表项 (`ProgramFilesDir`, `ProgramW6432Dir`,`ProgramFilesDir (x86)`) 并创建 NTFS 联接 (Junctions)，在不破坏系统依赖的前提下实现数据重定向。



## 免责声明

本工具会修改注册表项 (`HKLM`)。虽然脚本内置了安全检查，但请确保在进行系统级操作前备份关键数据。使用风险由用户自行承担。

## 许可

本项目基于 MIT 协议开源。
