# REAPER Font 12 Patcher

Automatically change REAPER's native Windows dialog fonts to **12pt**.

自动将 Windows 版 REAPER 原生对话框字体修改为 **12pt**。

**[🇬🇧 English](#english) | [🇨🇳 中文](#中文)**

---

<a id="english"></a>

# 🇬🇧 English

## About

This project provides Windows batch scripts for changing the font size of REAPER's native Windows dialogs.

The script searches REAPER's Dialog resources for entries using:

```text
FONT ..., "MS Shell Dlg"
```

and changes them to:

```text
FONT 12, "MS Shell Dlg"
```

This can make REAPER's native Preferences and other Windows dialogs easier to read, especially on high-DPI displays.

> **This project is unofficial and is not affiliated with or endorsed by Cockos or REAPER.**

---

## REAPER and the evaluation version

REAPER can be downloaded from the official website and evaluated with full functionality for **60 days**.

After the evaluation period, a REAPER license is required.

[Download REAPER](https://www.reaper.fm/download.php) · [Purchase a REAPER License](https://www.reaper.fm/purchase.php)

---

## Requirements

* Windows
* REAPER for Windows
* [Resource Hacker](https://www.angusj.com/resourcehacker/)
* Administrator privileges

---

## Two Scripts

This repository provides **two versions of the patching script**.

### 1. Fixed-path version

The fixed-path script is designed around the development environment used to create and test this project.

It assumes specific locations for:

* REAPER
* Resource Hacker
* the working/build environment

This version is **more predictable in the environment it was designed for**, but it is not intended to be universally portable.

It may need to be edited if your installation paths are different.

**Recommended for:** users who understand the script and are comfortable editing Windows paths.

---

### 2. Automatic-search version

The automatic version attempts to locate:

* `reaper.exe`
* `ResourceHacker.exe`

automatically.

It checks several common locations and can also search under Program Files.

This makes it easier to use on computers with different installation paths.

However:

> **Automatic detection is not guaranteed to work on every computer.**

For example, it may fail if:

* REAPER is installed in an unusual location
* Resource Hacker is stored somewhere unexpected
* multiple copies of REAPER are installed
* Windows permissions prevent the required operations
* a future REAPER version changes its internal resource structure

If automatic detection fails, use the fixed-path version or follow the manual Resource Hacker procedure below.

---

## Recommended workflow

### Automatic method

1. Install REAPER.
2. Install or extract Resource Hacker.
3. Download the automatic script.
4. Right-click the `.bat` file.
5. Select **Run as administrator**.
6. Wait for the script to finish.
7. The script creates:

```text
reaper_custom.exe
```

The original `reaper.exe` is not overwritten.

---

## Manual Resource Hacker method

If the scripts do not work, the patch can also be performed manually with Resource Hacker.

### Step 1 — Open REAPER

Open your original REAPER executable in Resource Hacker.

For example:

```text
C:\Program Files\REAPER (x64)\reaper.exe
```

---

### Step 2 — Open Dialog resources

In the left-hand tree, locate:

```text
Dialog
```

There may be many numeric Dialog resources.

You do **not** need to edit them one by one.

---

### Step 3 — Save the Dialog resource group

Use Resource Hacker's option to save/export the Dialog resource group as an `.rc` resource script.

For example:

```text
dialogs.rc
```

---

### Step 4 — Edit the RC file

Open `dialogs.rc` with a text editor that can preserve UTF-16 encoding.

Look for entries such as:

```text
FONT 8, "MS Shell Dlg"
```

Change them to:

```text
FONT 12, "MS Shell Dlg"
```

The script in this repository performs this replacement automatically for all matching entries.

---

### Step 5 — Compile the modified resources

Compile the modified `.rc` file back into a `.res` file using Resource Hacker.

For example:

```text
dialogs.res
```

---

### Step 6 — Create a copy of REAPER

**Do not overwrite the original `reaper.exe`.**

First make a copy, for example:

```text
reaper_custom.exe
```

Then use Resource Hacker to replace/add the modified Dialog resources in the copied executable.

---

### Step 7 — Run the modified version

Run:

```text
reaper_custom.exe
```

The original REAPER remains available as a fallback.

---

## How the automatic script works

The automatic script essentially performs the following process:

```text
Current REAPER
      │
      ▼
Locate reaper.exe
      │
      ▼
Locate ResourceHacker.exe
      │
      ▼
Extract Dialog resources
      │
      ▼
Find all "MS Shell Dlg" FONT entries
      │
      ▼
Change FONT size to 12
      │
      ▼
Compile modified resources
      │
      ▼
Copy original REAPER
      │
      ▼
Inject modified Dialog resources
      │
      ▼
reaper_custom.exe
```

The script also checks whether the expected `MS Shell Dlg` entries exist.

If none are found, it stops instead of silently creating a potentially incorrect executable.

---

## After a REAPER update

A REAPER update replaces the original executable with a newer version.

After updating REAPER, simply run the patch script again.

The script starts from the current original:

```text
reaper.exe
```

and generates a new:

```text
reaper_custom.exe
```

Therefore, the patch does not need to be manually recreated after every update, as long as the new REAPER version still uses the expected Dialog resource structure.

---

## Compatibility

This project currently targets:

* Windows
* Windows versions of REAPER
* REAPER Dialog resources using `MS Shell Dlg`

A future REAPER version may change its internal resource structure.

If that happens, the script may stop with an error rather than successfully creating a patched executable.

This behavior is intentional: failing clearly is preferable to silently generating an incorrect file.

---

## Important notes

### Original REAPER is not modified

The scripts create a separate:

```text
reaper_custom.exe
```

rather than replacing the original REAPER executable.

Keep the original `reaper.exe` as a backup.

### Security warnings

Windows Defender or SmartScreen may display a warning because the resulting executable has been modified.

Only use files and scripts that you have inspected and understand.

### Unofficial project

This is a community-made utility.

It is not an official Cockos or REAPER product.

[REAPER Official Website](https://www.reaper.fm/)

[REAPER Download](https://www.reaper.fm/download.php)

[Resource Hacker Official Website](https://www.angusj.com/resourcehacker/)

---

<a id="中文"></a>

# 🇨🇳 中文

## 项目简介

本项目提供 Windows 批处理脚本，用于自动修改 REAPER 原生 Windows 对话框的字体大小。

脚本会寻找 REAPER Dialog 资源中的：

```text
FONT ..., "MS Shell Dlg"
```

并修改为：

```text
FONT 12, "MS Shell Dlg"
```

这样可以增大 REAPER 的 Preferences（首选项）以及其他原生 Windows 对话框中的文字。

对于 Windows 高 DPI / 高缩放环境，这可以让 REAPER 的原生界面更加容易阅读。

> **本项目为非官方社区工具，与 Cockos / REAPER 没有官方关联。**

---

## REAPER 是免费的吗？

REAPER 可以从官方网站免费下载，并提供 **60 天完整功能试用**。

试用期结束后，需要购买 REAPER 许可证。

[下载 REAPER](https://www.reaper.fm/download.php) · [购买 REAPER 许可证](https://www.reaper.fm/purchase.php)

---

## 使用要求

需要：

* Windows
* Windows 版 REAPER
* [Resource Hacker](https://www.angusj.com/resourcehacker/)
* Windows 管理员权限

---

## 本项目提供两个脚本

本项目提供**两个版本**的脚本。

### 1. 固定路径版本

第一个脚本是根据开发和测试时使用的电脑环境制作的。

它依赖特定的：

* REAPER 路径
* Resource Hacker 路径
* 工作 / 编译环境

因此这个版本**不保证能够直接在其他电脑上运行**。

如果你的 REAPER 或 Resource Hacker 安装位置不同，需要打开 BAT 文件修改对应路径。

这个版本适合：

> 熟悉 Windows 路径，并愿意根据自己电脑情况修改脚本的用户。

---

### 2. 自动搜索版本

第二个脚本会尝试自动寻找：

```text
reaper.exe
ResourceHacker.exe
```

它会首先检查一些常见安装位置，如果找不到，还会尝试搜索 Program Files。

因此它比固定路径版本更加方便。

但是：

> **自动搜索并不保证在所有电脑上都能成功。**

例如以下情况可能导致自动搜索失败：

* REAPER 安装在非常规位置
* Resource Hacker 放在特殊位置
* 电脑中安装了多个 REAPER
* Windows 权限限制
* 未来 REAPER 修改了内部资源结构

如果自动版本无法工作，可以使用固定路径版本，或者按照下面的手动 Resource Hacker 方法操作。

---

## 推荐使用方法

### 自动版本

1. 安装 REAPER。
2. 安装或解压 Resource Hacker。
3. 下载自动搜索版本的 BAT。
4. 右键 BAT 文件。
5. 选择：

**以管理员身份运行**

6. 等待脚本完成。
7. 脚本会生成：

```text
reaper_custom.exe
```

原始的：

```text
reaper.exe
```

不会被覆盖。

---

## 手动使用 Resource Hacker

如果两个脚本都无法正常运行，也可以直接使用 Resource Hacker 手动完成修改。

### 第一步：打开 REAPER

使用 Resource Hacker 打开原始 REAPER：

```text
C:\Program Files\REAPER (x64)\reaper.exe
```

你的实际安装路径可能不同。

---

### 第二步：找到 Dialog

在 Resource Hacker 左侧资源树中找到：

```text
Dialog
```

里面通常会有大量数字编号的 Dialog 资源。

**不需要一个一个修改。**

---

### 第三步：导出 Dialog 资源

使用 Resource Hacker 将 Dialog 资源组保存 / 导出为 `.rc` 文件。

例如：

```text
dialogs.rc
```

---

### 第四步：修改字体

使用可以正确保存 UTF-16 文件的文本编辑器打开：

```text
dialogs.rc
```

找到类似：

```text
FONT 8, "MS Shell Dlg"
```

修改为：

```text
FONT 12, "MS Shell Dlg"
```

如果存在很多这样的条目，需要全部修改。

本项目提供的脚本就是自动完成这个批量替换。

---

### 第五步：重新编译

使用 Resource Hacker 将修改后的：

```text
dialogs.rc
```

重新编译为：

```text
dialogs.res
```

---

### 第六步：复制 REAPER

**不要直接覆盖原始 `reaper.exe`。**

先复制一份：

```text
reaper.exe
```

例如命名：

```text
reaper_custom.exe
```

---

### 第七步：替换 Dialog 资源

使用 Resource Hacker 将刚刚生成的：

```text
dialogs.res
```

注入到：

```text
reaper_custom.exe
```

中的 Dialog 资源。

---

### 第八步：运行修改版

最后运行：

```text
reaper_custom.exe
```

原来的：

```text
reaper.exe
```

仍然保留。

---

## 自动脚本的工作流程

自动脚本实际上就是把上面的手动过程自动化：

```text
当前 REAPER
      │
      ▼
寻找 reaper.exe
      │
      ▼
寻找 ResourceHacker.exe
      │
      ▼
提取 Dialog 资源
      │
      ▼
寻找所有 "MS Shell Dlg" FONT
      │
      ▼
统一修改为 12pt
      │
      ▼
重新编译资源
      │
      ▼
复制原始 REAPER
      │
      ▼
注入修改后的 Dialog
      │
      ▼
生成 reaper_custom.exe
```

脚本还会检查是否真的找到了预期的：

```text
MS Shell Dlg
```

字体条目。

如果一个都没有找到，脚本会停止并报告错误，而不是生成一个可能不正确的 EXE。

---

## REAPER 更新以后怎么办？

如果 REAPER 更新：

```text
reaper.exe
```

会变成新的版本。

这时只需要再次运行脚本。

脚本会从新的原始：

```text
reaper.exe
```

重新开始：

```text
新的 REAPER
      ↓
重新提取
      ↓
重新修改
      ↓
重新编译
      ↓
新的 reaper_custom.exe
```

因此不需要每次更新 REAPER 后手动重新修改所有 Dialog。

只要新的 REAPER 仍然使用预期的 Dialog 资源结构，脚本就有可能继续工作。

---

## 兼容性

目前本项目针对：

* Windows
* Windows 版 REAPER
* 使用 `MS Shell Dlg` 的 REAPER Dialog 资源

未来 REAPER 可能改变内部资源结构。

如果发生这种情况，脚本可能无法继续工作。

这是有意设计的：

> **宁可明确报告失败，也不要悄悄生成一个可能有问题的修改版 REAPER。**

---

## 注意事项

### 不要覆盖原始 REAPER

脚本生成：

```text
reaper_custom.exe
```

而不是直接修改：

```text
reaper.exe
```

建议始终保留原始 REAPER。

### Windows 安全提示

因为生成的 EXE 内部资源经过修改，Windows Defender 或 SmartScreen 可能显示安全警告。

请只运行你已经检查并理解的脚本。

### 非官方项目

本项目是社区制作的工具。

它不是 Cockos / REAPER 官方产品。

[REAPER 官方网站](https://www.reaper.fm/)

[REAPER 下载](https://www.reaper.fm/download.php)

[Resource Hacker 官方网站](https://www.angusj.com/resourcehacker/)

---

## Links / 链接

* [REAPER Official Website](https://www.reaper.fm/)
* [REAPER Download](https://www.reaper.fm/download.php)
* [REAPER Purchase](https://www.reaper.fm/purchase.php)
* [Resource Hacker](https://www.angusj.com/resourcehacker/)
* [REAPER Distribution Agreement](https://www.reaper.fm/dist-agreement.php)

**[⬆ Back to English / 返回英文](#english)**
