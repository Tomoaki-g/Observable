import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CounterLessonView()
                .tabItem { Label("実験", systemImage: "slider.horizontal.3") }
            SettingsLessonView()
                .tabItem { Label("共有設定", systemImage: "person.crop.circle") }
            LearningGuideView()
                .tabItem { Label("学習ガイド", systemImage: "book") }
        }
    }
}

#Preview {
    ContentView().environment(AppSettings())
}
