# Tiny VCC
<p>
  <a href="https://github.com/kurotu/tiny_vcc/releases/latest">
    <img alt="Release" src="https://img.shields.io/github/v/release/kurotu/tiny_vcc">
  </a>
</p>

Yet Another VRChat Creator Companion for macOS and Windows.

[ [ダウンロード](https://github.com/kurotu/tiny_vcc/releases/latest) ]

[ [English](./README.md) | 日本語 ]

## 概要

macOS/Windows で使用可能な VCC の代替アプリケーションです。
VPM CLI の GUI ラッパーとして動作し、 VCC の機能のうち以下の機能を提供します。

- プロジェクトとパッケージの管理
- レガシープロジェクトから VCC 対応プロジェクトへの移行
- プロジェクトのバックアップ

## インストール

### 必須ソフトウェア
あらかじめ以下のソフトウェアをインストールしてください。

- [.NET 6.0 SDK](https://dotnet.microsoft.com/download/dotnet/6.0)
- [Unity Hub](https://unity.com/ja/download#how-get-started)
- Unity ([VRChat で指定されているバージョン](https://docs.vrchat.com/docs/current-unity-version))
  - Android Build Support (Quest 用にアップロードする場合)
  - Windows Build Support (macOS でアップロードする場合)

### Tiny VCC

#### Windows
1. [最新のリリース](https://github.com/kurotu/tiny_vcc/releases/latest) から `tiny_vcc-vX.X.X.zip` をダウンロードし、任意の場所に展開します。
2. 展開したフォルダの中にある `tiny_vcc.exe` を実行します。

#### macOS
1. [最新のリリース](https://github.com/kurotu/tiny_vcc/releases/latest) から `TinyVCC-vX.X.X.dmg` をダウンロードし、開きます。
2. 表示されたウィンドウにある `Tiny VCC` を `Applications` フォルダにドラッグ&ドロップします。
3. `Applications` フォルダを開き、 `Tiny VCC` を右クリックして「開く」を選択します。

## 動作確認済み環境
- Windows 10 21H2
- macOS Big Sur 11.7.2 (Intel)
- VPM CLI 0.1.13

## ライセンス
[GPLv3](./LICENSE) で提供されます。

## 連絡先・フィードバック
- VRCID: kurotu
- Twitter: [@kurotu](https://twitter.com/kurotu)
- GitHub: [kurotu/tiny_vcc](https://github.com/kurotu/tiny_vcc)
