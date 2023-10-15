# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### 削除
- VPM CLI のインストール時のバージョン固定をしないように変更。

### 修正

- [macOS] Apple Silicon で Unity のインストールができない問題を修正。
- [Windows] AMD CPU の Windows 11 でアーキテクチャの検出ができない問題を修正。
- Unity のパスを手動選択しても正しく保存されない問題を修正。
- Unity のバージョンチェックを修正。

## [0.5.0] - 2023-10-01

### 追加

- 韓国語表示を追加。 (by [Kieaer](https://github.com/Kieaer))

## [0.4.0] - 2023-03-21

### 追加

- ダークテーマを追加。
- 日本語表示を追加。
- 簡体字中国語表示を追加。 (by [Sonic853](https://github.com/Sonic853))

### 変更

- メインページを新しいレイアウトに変更。

## [0.3.0] - 2023-01-09

### 追加

- 必須ソフトウェアのインストールを自動化
- [Windows] インストーラー setup.exe を追加。

### 変更

- 必須ソフトウェアページを新しいレイアウトに変更。

## [0.2.0] - 2023-01-04

### 追加

- ダークモードを追加。
- ウィンドウの幅が広い場合のレイアウトを追加。
- プロジェクトをごみ箱に移動するメニューを追加。

### 変更

- 内部の状態管理を変更し、アプリの応答を改善。

### 修正

- StarterVPM プロジェクトを追加できない問題を修正。
- VCC の settings.json がない場合に正常に起動しない問題を修正。
- [macOS] バックアップフォルダの選択ダイアログが開かない問題を修正。

## [0.1.0] - 2022-12-31

### 追加

- 設定画面に設定フォルダを開くボタンを追加。
- 必要ソフトウェアを表示する画面を追加。
- ログ機能を追加。ログは以下のフォルダに保存されます。
    - Windows: `%USERPROFILE%\AppData\Loaming\kurotu\Tiny VCC\logs`
    - macOS: `~/Library/Application Support/com.github.kurotu.tiny-vcc/logs`
- インストールされた Unity を検出するボタンを追加。

### 変更

- 必須ソフトウェアのチェックで Unity Hub を実行する回数を減少。

### 修正

- AvatarGit または WorldGit プロジェクトを追加するとアプリがクラッシュする問題を修正。
- .NET や VPM CLI がインストールされていてもアプリがクラッシュすることがある問題を修正。
- プロジェクトを作成するとき最後のプロジェクト保存場所が保存されていない問題を修正。

## [0.0.2] - 2022-12-22

### 修正

- [macOS] インストールされた Unity を正しく検出できない問題を修正。
- 新しいプロジェクトを作成する画面でテキスト入力欄が正しく動作しない問題を修正。
- 更新確認が正しく初期化されない問題を修正。

## [0.0.1] - 2022-12-21

- 初版。
