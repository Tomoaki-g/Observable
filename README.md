# Observable Lab

SwiftUI の `@Observable` を、小さな iOS アプリで試しながら学ぶためのベースプロジェクトです。日本語のコメントと画面内ガイドを用意しています。外部ライブラリは使いません。

## 起動方法

1. Xcode 15 以降で `ObservableLab.xcodeproj` を開きます。
2. Scheme を `ObservableLab`、実行先を iOS 17 以降の iPhone / iPad Simulator にします。
3. `⌘R` で実行します。テストは `⌘U` です。

実機では Signing & Capabilities で自分の Team を選択してください。データはメモリ上だけに保持し、アプリを終了すると初期値に戻ります。

## 学習の順番

| 順番 | テーマ | 読む場所 | 操作 |
| --- | --- | --- | --- |
| 1 | `@Observable` と `@State` | `Models/CounterModel.swift`、`Views/CounterLessonView.swift` | カウントの増減・リセット |
| 2 | `@Bindable` | `CounterEditor` | 名前・増減幅を編集 |
| 3 | `@Environment` | `ObservableLabApp.swift`、`Views/SettingsLessonView.swift` | 共有設定の名前を変えて実験タブへ戻る |
| 4 | `@ObservationIgnored` | `IgnoredPropertySection` | 通知しない変更と表示の作り直しを比較 |

詳しい解説と練習問題は [docs/LEARNING.md](docs/LEARNING.md) にあります。

## 最小の形

```swift
import Observation
import SwiftUI

@Observable
final class Counter {
    var count = 0
}

struct CounterView: View {
    @State private var counter = Counter()

    var body: some View {
        Button("Count: \(counter.count)") {
            counter.count += 1
        }
    }
}
```

`@Observable` はプロパティへのアクセスと変更を追跡するコードを生成します。SwiftUI は `body` の評価中に読み取った observable プロパティへの依存を記録します。`@State` はこの画面が所有するモデルのインスタンスを保持します。

## 構成

```text
ObservableLab/
  ObservableLabApp.swift       # @State と .environment による共有モデルの所有・注入
  Models/
    CounterModel.swift        # カウント、計算プロパティ、通知しない値
    AppSettings.swift         # 複数画面で共有する設定
  Views/
    ContentView.swift         # タブ
    CounterLessonView.swift   # @Observable / @State / @Bindable の実験
    SettingsLessonView.swift # @Environment + @Bindable
    LearningGuideView.swift   # 日本語の学習ガイド
ObservableLabTests/           # 変更通知・依存追跡・カウンターのテスト
project.yml                  # XcodeGen 用のプロジェクト定義
```

Xcode プロジェクトはコミット済みなので XcodeGen のインストールは不要です。構成を変えて再生成する場合だけ `brew install xcodegen` → `xcodegen generate` を実行してください。

## コマンドでの確認

```sh
# 署名なしの Simulator 向けビルド
xcodebuild -project ObservableLab.xcodeproj -scheme ObservableLab \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/ObservableLabBuild CODE_SIGNING_ALLOWED=NO build

# インストール済み Simulator の名前に合わせる
xcodebuild -project ObservableLab.xcodeproj -scheme ObservableLab \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -derivedDataPath /tmp/ObservableLabBuild CODE_SIGNING_ALLOWED=NO test
```

GitHub Actions では Simulator 向けビルドとユニットテストを実行します。

## 公式資料

- [Managing model data in your app](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app)
- [Observation](https://developer.apple.com/documentation/observation)
- [Migrating from ObservableObject to Observable](https://developer.apple.com/documentation/swiftui/migrating-from-the-observable-object-protocol-to-the-observable-macro)
