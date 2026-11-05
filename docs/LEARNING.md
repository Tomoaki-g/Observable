# @Observable を理解する

## 1. まずは役割を分ける

| 仕組み | 役割 | このプロジェクトの例 |
| --- | --- | --- |
| `@Observable` | クラスのプロパティの読み取り・変更を追跡できるようにするマクロ | `CounterModel` |
| `@State` | View / App が所有するモデルを保持する | `CounterLessonView.model` |
| 通常の `let` / `var` | 渡されたモデルを参照する。body で読めば追跡される | `CounterReadout.model` |
| `@Bindable` | observable モデルから `$model.name` のような Binding を作る | `CounterEditor.model` |
| `.environment(model)` | モデルを子孫 View に注入する | `ObservableLabApp` |
| `@Environment(Model.self)` | 注入されたモデルを型で取得する | `SettingsLessonView` |
| `@ObservationIgnored` | その保存プロパティを自動追跡から除外する | `CounterModel.debugNote` |

`@Observable` 自体は SwiftUI 専用ではなく、Observation フレームワークの機能です。対応する SwiftUI の仕組みは iOS 17 以降で使えます。

## 2. 読んだ値が依存になる

`CounterReadout.body` は `count` と `status` を読みます。`status` の内部でも `count` を読むため、カウントが変わると更新対象になります。`name` だけを変更しても、カウント表示自身にはそのプロパティへの依存はありません。

ただし SwiftUI が別の理由で body を再評価する可能性はあります。「変更ごとに必ず1回だけ描画される」とは考えないでください。モデルの通知を厳密に確認する例は `CounterModelTests` の `withObservationTracking` を参照してください。

`withObservationTracking` の通知は一度限りで、変更前に呼ばれます。継続して監視する場合には再登録が必要です。このアプリでは画面の追跡は SwiftUI に任せています。

## 3. 所有と編集は別の役割

画面がモデルを生成し保持する場合は `@State private var model = CounterModel()` を使います。子 View に渡して読むだけなら `let model: CounterModel` で十分です。

`TextField` や `Stepper` が必要とする `Binding` は `@Bindable` から作れます。`@Bindable` はモデルのインスタンスを所有・保持するための仕組みではありません。

`@Environment` で取得したモデルを編集するときは、body 内に `@Bindable var settings = settings` を置き、`$settings.learnerName` を使います。型を指定して取得するモデルは、Preview を含め `.environment(AppSettings())` などで事前に注入する必要があります。

## 4. 通知しない値でも、値自体は変わる

実験タブの①で `debugNote` を変えても、その変更は更新を通知しません。②で表示を作り直すと、新しい値を読めます。`@ObservationIgnored` は値を固定するものではありません。

## 5. ObservableObject との対応

| 従来の仕組み | Observation を使う場合 |
| --- | --- |
| `class Model: ObservableObject` | `@Observable class Model` |
| `@Published var count` | `var count` |
| `@StateObject` で所有 | `@State` で所有 |
| `@ObservedObject` で参照 | 通常のプロパティ。Binding が必要なら `@Bindable` |
| `@EnvironmentObject` と `.environmentObject` | `@Environment(Model.self)` と `.environment` |

既存の Combine ベースの処理や対応 OS によって移行判断は変わります。この表は本プロジェクトのような SwiftUI のデータ共有を理解するための対応です。

## 練習問題

1. `CounterModel` に `var target = 10` と `var isTargetReached: Bool { count >= target }` を追加し、目標達成の表示を作る。
2. `@Bindable` を使って目標値を変更できる `Stepper` を追加する。
3. `AppSettings` に新しい設定を追加し、別タブから変更した結果を実験タブで表示する。
4. `name` を読んだ場合の通知テストを追加する。`count` を変えただけでは通知されないことも確認する。

このベースでは永続化・通信・非同期処理を扱いません。次の段階で保存や非同期処理を追加する際は、`@Observable` が自動で永続化やスレッド安全性を提供するわけではない点に注意してください。

解説の基礎は [Apple のモデルデータ管理ガイド](https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app) と [Observation ドキュメント](https://developer.apple.com/documentation/observation) です。
