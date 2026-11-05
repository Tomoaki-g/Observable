import SwiftUI

@main
struct ObservableLabApp: App {
    // @State が参照型モデルのインスタンスを画面のライフサイクルに保持する。
    @State private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
        }
    }
}
