<h4 align="right">
  <a href="README.md">简体中文</a> | <strong>English</strong>
</h4>

<h1 align="center">⚡ Bettbox</h1>
<p align="center">
  <strong>Another Better Mihomo Client</strong>
</p>

Bettbox is a multi-platform proxy client based on the early version of FlClash, refactored and powered by the Mihomo (Clash Meta) core.

Following the principle of "Better Experience", Bettbox inherits the excellent user interface of the original version while deeply optimizing numerous details, features, and internal logic. It aims to be a Mihomo client that delivers a smoother foreground experience, a highly power-efficient and silent background operation, and long-term stability.

The name "Bettbox" stands for: **Better Experience, Out of the box**.

[![Latest Release](https://img.shields.io/github/v/release/appshubcc/Bettbox?style=for-the-badge&logo=github&color=238636&label=Release)](https://github.com/appshubcc/Bettbox/releases/latest) [![Core](https://img.shields.io/github/v/release/MetaCubeX/mihomo?style=for-the-badge&logo=go&logoColor=white&color=8A2BE2&label=Mihomo)](https://github.com/MetaCubeX/mihomo/releases/latest) [![Downloads](https://img.shields.io/github/downloads/appshubcc/Bettbox/total?style=for-the-badge&logo=github&color=007ec6)](https://github.com/appshubcc/Bettbox/releases) 

---

## 🛠️ Installation and Download

Please visit the [Releases](https://github.com/appshubcc/Bettbox/releases) page to download the latest installer suitable for your platform and system.

* **Desktop Platforms**: Windows (x64/arm64), macOS (Intel/Apple Silicon), Linux (x64/arm64)
* **Windows 7**: Please use in conjunction with [[VxKex]](https://github.com/i486/VxKex/releases)
* **Android**: Android (ARMv8 / ARMv7 / x86_64 / Universal) 
* **Android TV**: Adapted, optional ARMv7 32-bit
* **HarmonyOS NEXT**: Please use in conjunction with [[ZhuoYiTong]](https://harmonyos.cool/android-app)

---

### ✈️ Telegram Community

<div align="left">

[![Telegram Group](https://img.shields.io/badge/Appshub-Chat-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_chat) [![Telegram Channel](https://img.shields.io/badge/Appshub-Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_channel)

---
</div>

## 🚀 Core Features

### Deep Experience Optimization
* **Out of the box**: Stable permission handling and a comfortable TUN/VPN experience. It comes with pre-configured routing rules optimized for specific regions, allowing you to reach the best state right out of the box.
* **Refined Details**: Polished UI and interaction details, lightweight and stable background operation, low power consumption on mobile devices, and low resource usage on desktop platforms.

### Security and Stability
* **Security Guardian**: The core engine closely follows the Mihomo mainline and actively adapts to new features, maintaining strict permission control and validation across multiple platforms.
* **Resilience and Fault Tolerance**: Optimized stability in extreme scenarios, built-in elegant fallback mechanisms for configuration errors, ensuring continuous and reliable service.

### Highly Customizable
* **Visual Configuration**: Provides a rich set of visual adjustment interfaces. All changes take effect immediately without the need for tedious manual configuration edits.
* **Dashboard Widgets**: Built-in exquisite widgets allowing you to intuitively monitor real-time network speed and overall status on the dashboard.
* **Personalization**: Supports rich color themes, custom icons/titles, and even includes 10 beautiful network speed testing animations.

### Multi-Platform and Performance
* **Ultimate Performance**: Native multi-platform support including desktop ARM64 architecture, providing hardware performance grading and overall Flutter performance optimization.
* **Device Compatibility**: Continuously maintains compatible versions for older operating systems and hardware, extending the lifecycle of your devices.
* **Community-Oriented**: We carefully evaluate community feedback, prioritize high-quality issues, and ensure your voice is heard.

### Open Source and Transparent
* **Automated Builds**: Fully transparent CI/CD process based on GitHub Actions. The code is the product, what you see is what you get.
* **Zero Privacy Risk**: Completely free and ad-free. The code is open-source and subject to comprehensive auditing, eliminating any background privacy collection.

---

## ❓ FAQ

1. **Unable to start after installation?**
   - For older Android devices, please ensure they meet the minimum system requirement: Android 8.0+.
   - For older Desktop devices, check if you need to download the CPU-specific "Compatible" version.
   - If the issue persists, please submit an ISSUE for feedback.

2. **Common Desktop Issues**
   - Windows Administrator Permissions: Bettbox pre-handles this during installation, no manual authorization is needed.
   - Unable to enable TUN virtual network adapter: On macOS and Linux, please ensure you enter the correct password to grant permissions.
   - Other errors: Please provide logs and ensure there are no conflicting proxy software or services running.
   - If the issue persists, please submit an ISSUE.

3. **Unable to import subscription links**
   - Please try resetting the link first and ensure the link is working before importing.
   - Ensure you are importing a Clash (Mihomo) formatted subscription link.
   - If the issue persists, please submit an ISSUE.

4. **To be continued...**

---

## 💻 Development and Build

Taking Windows as an example:

* You need a Windows device (≥ Windows 10)
* Required software dependencies: Visual Studio, Flutter SDK ≥ 3.44, Golang, Inno Setup, Rust
* Run command: `dart .\setup.dart windows --arch amd64 --compatible` (compatible version is optional)

---

## ❤️ Acknowledgements

The birth of Bettbox relies on the following foundational projects:

* [FlClash](https://github.com/chen08209/FlClash) - An excellent open-source project by Chen
* [Mihomo](https://github.com/MetaCubeX/mihomo) - A powerful, flexible, and stable proxy core

During the development and build process, we also drew inspiration from the following open-source projects (ranked in order of reference):

[CMFA](https://github.com/MetaCubeX/ClashMetaForAndroid), [Sparkle](https://github.com/xishang0128/sparkle), [SFA](https://github.com/SagerNet/sing-box-for-android), [HUSI](https://github.com/xchacha20-poly1305/husi), [V2rayN](https://github.com/2dust/v2rayN)

---

## 📄 License

Continuing the original project's GPL-3.0 open-source license.
