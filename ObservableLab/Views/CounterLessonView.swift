import SwiftUI

struct CounterLessonView: View {
    // この画面がモデルを所有する。再描画されても同じインスタンスを保持する。
    @State private var model = CounterModel()

    var body: some View {
        NavigationStack {
            Form {
                Section("1. @Observable + @State") {
                    CounterReadout(model: model)
                    HStack {
                        Button { model.decrement() } label: {
                            Label("減らす", systemImage: "minus.circle")
                        }
                        Spacer()
                        Button { model.increment() } label: {
                            Label("増やす", systemImage: "plus.circle.fill")
                        }
                    }
                    .buttonStyle(.bordered)
                    Button("カウントをリセット") { model.reset() }
                }

                CounterEditor(model: model)
                LearnerSection()
                IgnoredPropertySection(model: model)
            }
            .navigationTitle("Observation Lab")
        }
    }
}

private struct CounterReadout: View {
    // 読み取りだけなら @ObservedObject も @Bindable も不要。
    let model: CounterModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(model.count, format: .number)
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.tint)
            Text(model.status).font(.subheadline)
        }
        .padding(.vertical, 8)
    }
}

private struct CounterEditor: View {
    // $model.name / $model.step を作り、コントロールと双方向に接続する。
    @Bindable var model: CounterModel

    var body: some View {
        Section("2. @Bindable で編集") {
            TextField("名前", text: $model.name)
            Text("こんにちは、\(model.name) さん")
            Stepper("増減幅: \(model.step)", value: $model.step, in: 1...10)
        }
    }
}

private struct IgnoredPropertySection: View {
    let model: CounterModel
    @State private var refreshID = 0

    var body: some View {
        Section {
            // サブビューの identity を変えたときに、値を読み直す。
            IgnoredNoteReadout(model: model).id(refreshID)
            Button("① 通知せずに値を変更") {
                model.debugNote = "変更済み（通知なし）"
            }
            Button("② 表示を作り直して値を確認") { refreshID += 1 }
            Text("①だけでは通知されません。②で表示を作り直すと変更後の値が見えます。他の理由で再描画された場合にも最新値が表示されることがあります。")
                .font(.caption)
                .foregroundStyle(.secondary)
        } header: {
            Text("4. @ObservationIgnored")
        }
    }
}

private struct IgnoredNoteReadout: View {
    let model: CounterModel

    var body: some View {
        Text(model.debugNote)
    }
}

private struct LearnerSection: View {
    // App から注入された、共有設定と同じインスタンスを取得する。
    @Environment(AppSettings.self) private var settings

    var body: some View {
        Section("3. @Environment で共有") {
            Text("\(settings.learnerName) さんの実験室")
            if settings.showsHints {
                Text("「共有設定」で名前を変更すると、この表示にも反映されます。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    CounterLessonView().environment(AppSettings())
}
