<h4 align="right">
  <a href="README.md">简体中文</a> | <a href="README_en.md">English</a> | <a href="README_ru.md">Русский</a> | <a href="README_fa.md">فارسی</a> | <strong>日本語</strong> | <a href="README_ko.md">한국어</a>
</h4>

<h1 align="center">⚡ Bettbox</h1>
<p align="center">
  <strong>Another Better Mihomo Client</strong>
</p>

**Bettboxは、Mihomo（Clash Meta）カーネルを使用し、FlClashの初期バージョンをベースに再構築された、マルチプラットフォーム対応のネットワークデバッグおよびトラフィック分流クライアントです。**

「Better Experience（より良い体験）」の原則に基づき、Bettboxはオリジナルの優れたUIを継承しつつ、多くの詳細なロジックや実用機能を深く最適化しています。フロントエンドは滑らかに動作し、バックグラウンドは省電力で動作する、長期的に安定して稼働できるMihomoクライアントを目指しています。

**サポートプロトコル**：Shadowsocks ( R / 2022 / ShadowTLS / Restls )、Trojan、VMess、VLESS ( XHTTP / Reality )、Hysteria ( v1 / v2 )、TUIC、WireGuard、Tailscale、OpenVPN、SSH、AnyTLS、Mieru、Snell ( v1-v5 )、Masque、TrustTunnel、Sudoku、Gost-relay、HTTP/Socks5 など。

Bettboxの意味：Better Experience, Out of the box（優れた体験を、インストールしてすぐに）。

[![Latest Release](https://img.shields.io/github/v/release/appshubcc/Bettbox?style=for-the-badge&logo=github&color=238636&label=Release)](https://github.com/appshubcc/Bettbox/releases/latest) [![Core](https://img.shields.io/github/v/release/MetaCubeX/mihomo?style=for-the-badge&logo=go&logoColor=white&color=8A2BE2&label=Mihomo)](https://github.com/MetaCubeX/mihomo/releases/latest) [![Downloads](https://img.shields.io/github/downloads/appshubcc/Bettbox/total?style=for-the-badge&logo=github&color=007ec6)](https://github.com/appshubcc/Bettbox/releases) 
---
### ✈️ Telegram コミュニティ

</div>

<div align="left">

[![Telegram Group](https://img.shields.io/badge/Appshub-Chat-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_chat) [![Telegram Channel](https://img.shields.io/badge/Appshub-Channel-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/appshub_channel)

---

## 🛠️ インストールとダウンロード

ご利用のプラットフォームおよびシステムに適した最新のインストールパッケージを **[[Releases]](https://github.com/appshubcc/Bettbox/releases)** ページからダウンロードしてください。

* **全デスクトッププラットフォーム**: **Windows** (x64/arm64), **macOS** (Intel/Apple Silicon), **Linux** (x64/arm64)
* **Android 端末**: Android (ARMv8/ ARMv7/ x86_64/ Universal)
* **Android TV**: 完全対応、ARMv7 32ビット版も選択可能
* **HarmonyOS NEXT**: [[卓易通]](https://harmonyos.cool/android-app) と組み合わせてご利用ください

**その他のインストール方法:**<br>
**ArchLinux:** <code>yay -S bettbox-bin または paru -S bettbox-bin</code><br>
**AMD64=v1:** <code>yay -S bettbox-compatible-bin または paru -S bettbox-compatible-bin</code>

---
</div>

## 🚀 主な特徴

* **すぐに使える**：安定した権限処理と快適な TUN/VPN 統合。多くの最適化と詳細設定があらかじめプリセットされており、インストールしてすぐに使えます。
* **洗練されたUI**：細部まで磨き上げられたUIとインタラクション。フロントエンドの滑らかな高フレームレートアニメーション、モバイル端末での低消費電力、デスクトップ端末での低リソース消費を実現。
* **セキュリティ**：カーネルはMihomoのメインラインを密に追従し、最新の機能を積極的にサポート。複数プラットフォームで厳格な権限管理と検証を維持します。
* **安定性と堅牢性**：複数プラットフォームの極端なシナリオにおける安定性を最適化。YAMLフォーマットの検証と早期の事前解析による二重のバグ・エラー検出機構を内蔵。
* **パフォーマンス優先**：デスクトップ端末でのネイティブ ARM64 アーキテクチャをサポート。ハードウェアの階層化と Flutter 全体の最適化により、ハードウェア性能を最大限に引き出します。
* **高度なツール**：初の複数プラットフォーム対応シームレススマート起動/停止、Androidスリープモード対応、ワンクリックQUIC無効化、システムトレイメニューの拡張などをサポート。
* **視覚的設定**：豊富なパラメータをUIから視覚的に調整可能。設定ファイルを直接書き換えることなく、変更が即座に反映されます。
* **ホームウィジェット**：ホーム画面でリアルタイムのネットワーク速度や全体の動作ステータスを直感的に監視できる、いくつかの洗練されたウィジェットを内蔵。
* **カスタマイズ**：豊富なカラーテーマ、カスタムアイコン/タイトルをサポート。10種類の美しいダイナミックネットワークスピードテストアニメーションも収録。
* **デバイス互換性**：古いシステムや古いハードウェア向けの Compatible（互換）バージョンを継続的にメンテナンスし、デバイスの寿命を延ばします。
* **プライバシーリスクゼロ**：オープンソース、広告なし。完全に透明化された CI/CD プロセスとオープンな監査に対応し、バックグラウンドでのテレメトリやデータ収集を厳格に禁止しています。
* **コミュニティ主導**：コミュニティからのフィードバックを真摯に受け止め、高品質な Issue を優先して対応します。あなたの声が無駄になることはありません。

---

## ❓ よくある質問

1.  **インストール後に起動できない？**
    - Android端末の場合、**十分なバックグラウンド権限が与えられているか、および最低システム要件を満たしているか**確認してください: Android 8.0+
    - 旧式のパソコンの場合、システムアーキテクチャに応じて**特定のCPU世代向けの Compatible（互換）バージョンをダウンロードする必要があるか**確認してください。
    - **セキュリティについて：Bettbox プロジェクトは完全にオープンソースで透明化されています。現在のコードはすでに Signpath 財団のセキュリティ監査に合格しています。**

2.  **デスクトップ端末における一般的な問題:**
    - Windowsの管理者権限：インストール時にあらかじめ自動処理されるため、**起動後の手動での権限付与は不要です**。
    - TUN仮想ネットワークカードを有効化できない：macOSおよびLinuxでは、**権限を付与するために正しいパスワードを入力しているか確認してください**。
    - その他のエラー：デバッグ情報を提供し、**競合する他のプロキシソフトウェアやサービスが動作していないことを確認してください**。
    - 問題が解決しない場合は、Issueを提出してください。

3.  **macOSインストールガイド:**
    - ご利用のプラットフォーム（Intel / Apple Silicon）に適したファイルをダウンロード後、Bettbox-macos-xx.dmgファイルをダブルクリックして開きます。
    - Bettboxのアイコンを「Applications（アプリケーション）」フォルダにドラッグ＆ドロップしてインストールを完了します。
    - **初回起動時のGatekeeper安全ブロックの回避方法**（現在Appleのデベロッパー証明書を購入していないため）：
      - **推奨**：「アプリケーション」フォルダに入り、**Bettboxアイコンを右クリック**して **「開く」** を選択し、確認ダイアログで再度 **「開く」** をクリックします。
      - **代替案**：ダブルクリックで開けない場合は、Macの「システム設定」 -> 「プライバシーとセキュリティ」に進み、Bettboxを見つけて **「このまま開く」** をクリックします。
    - 初めてTUNモードを有効にする際、パスワードの入力を求められます。Macのユーザーパスワードを入力して、Bettboxによるネットワーク構成を許可してください。
    - **「壊れているため開けません。ゴミ箱に入れる必要があります」と表示される場合:**
      - これは署名のないソフトウェアに対する macOS Gatekeeper の誤検知です。ターミナル（Terminal）を開き、以下のコマンドを実行して隔離フラグを解除してください：
        ```bash
        xattr -d com.apple.quarantine /Applications/Bettbox.app
        ```

4.  **購読リンクをインポートできない:**
    - インポートする前に、**リンクを一旦リセットして**、リンク自体が有効であることを必ず確認してください。
    - インポートするリンクが **Clash（Mihomo）フォーマット** であることを確認してください。
    - 問題が解決しない場合は、Issueを提出してください。

5.  **順次追加予定...**

---

## 💻 開発とビルド

Windowsを例にとると：

* Windows端末が必要です（OSバージョン ≥ Windows 10）
* その他の必要な環境：Git, Visual Studio, Flutter 3.44.x, Golang, Inno Setup, Rust
* `flutter pub get` (依存関係の取得)
* `dart .\setup.dart windows --arch amd64 --out core` (Coreコアのビルドのみ)
* `dart .\setup.dart windows --arch amd64 --out app --compatible` (互換バージョンのビルド、オプション)
* ビルド完了後、生成物は `dist/` ディレクトリに保存されます。

---

### ☕ 開発のサポート

**このプロジェクトが役に立ったと感じた場合は、以下の方法で開発を支援するか、上記の推奨リンクをご利用いただけます：**

* TRON (TRC-20): <code>TCkTtZfF2WrciZLaJj3e1aqrh3zdTnCkDa</code>
* EVM Compatible: <code>0xF8B1B39431013359D83F38a4e403087624618E67</code>
* Solana: <code>C2YQPcKR2YmrPtBvkE13wckjgescUfMA5HzUioR4rQUd</code>
* Bitcoin: <code>bc1qu950cl6035qvllmzk6cfw3l30j2lg3cq9n6g6h</code>

---

## ❤️ 謝辞

**[FlClash GUI](https://github.com/chen08209/FlClash)** - **[Mihomo Core](https://github.com/MetaCubeX/mihomo)**

* BettboxプロジェクトのWindowsデジタル署名は**[SignPath](https://signpath.io)**によって提供され、コードはセキュリティ監査を通過しています。
* オープンソースコミュニティへの多大なご支援に対して、**SignPath財団 (SignPath Foundation)**に心より感謝申し上げます。

その他のオープンソースプロジェクト（時系列順）：

[CMFA](https://github.com/MetaCubeX/ClashMetaForAndroid), [Sparkle](https://github.com/xishang0128/sparkle), [SFA](https://github.com/SagerNet/sing-box-for-android), [HUSI](https://github.com/xchacha20-poly1305/husi), [V2rayN](https://github.com/2dust/v2rayN)

---

## 📄 ライセンス

GPL-3.0ライセンスの下で公開されています。
