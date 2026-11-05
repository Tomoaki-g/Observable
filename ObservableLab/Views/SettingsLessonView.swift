import SwiftUI

struct SettingsLessonView: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        // @Environment の値から Binding を作るにはローカルの @Bindable を使う。
        @Bindable var settings = settings

        NavigationStack {
            Form {
                Section("3. 画面をまたいで同じモデルを使う") {
                    TextField("学習者の名前", text: $settings.learnerName)
                    Toggle("実験画面にヒントを表示", isOn: $settings.showsHints)
                }
                Section("確認してみよう") {
                    Text("名前を変えて「実験」タブに戻ると、学習者名が更新されます。")
                    Text("@Environment はモデルを取得し、@Bindable は編集用の Binding を作ります。")
                }
            }
            .navigationTitle("共有設定")
        }
    }
}

#Preview {
    SettingsLessonView().environment(AppSettings())
}
