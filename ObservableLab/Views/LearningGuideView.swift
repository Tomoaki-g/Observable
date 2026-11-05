import SwiftUI

struct LearningGuideView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("学ぶ順番") {
                    lesson("1. 変更を観察する", "CounterModel.swift の @Observable と、CounterLessonView の @State を読み、カウントを変更しましょう。")
                    lesson("2. 入力とモデルをつなぐ", "CounterEditor の @Bindable を読み、名前と増減幅を編集しましょう。")
                    lesson("3. 複数画面で共有する", "App の .environment(settings) と、各画面の @Environment をたどりましょう。")
                    lesson("4. 通知しない値を知る", "@ObservationIgnored の値を変更し、表示を作り直したときとの違いを試しましょう。")
                }
                Section("覚えておきたいこと") {
                    Text("View の body が読んだ observable プロパティの変更が、更新のきっかけになります。")
                    Text("@Observable だけで永続保存やスレッド安全性が得られるわけではありません。このアプリのデータは終了すると初期値に戻ります。")
                    Text("再描画の回数や順序は SwiftUI が判断します。プロパティの変更回数と一致するとは限りません。")
                }
                Section("公式ドキュメント") {
                    Link("Managing model data in your app", destination: URL(string: "https://developer.apple.com/documentation/swiftui/managing-model-data-in-your-app")!)
                    Link("Observation", destination: URL(string: "https://developer.apple.com/documentation/observation")!)
                }
            }
            .navigationTitle("学習ガイド")
        }
    }

    private func lesson(_ title: String, _ detail: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title).font(.headline)
            Text(detail).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LearningGuideView()
}
