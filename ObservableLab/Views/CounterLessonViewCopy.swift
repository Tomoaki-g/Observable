//
//  CounterLessonViewCopy.swift
//  ObservableLab
//
//  Created by takemoto on 2026/11/13.
//

import SwiftUI

struct CounterLessonViewCopy: View {
    @State private var model = CounterModel()

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("1.@Observation + @State")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(model.count, format: .number)
                            .font(.system(size: 56, weight: .bold))
                            .foregroundStyle(.tint)

                        Text("現在のカウントは\(model.count)です。")
                    }

                    HStack {
                        Button { model.decrement() } label: {
                            Label("減らす", systemImage: "minus.circle")
                        }

                        Spacer()

                        Button { model.increment() } label: {
                            Label("増やす", systemImage: "plus.circle")
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

private struct CounterEditor: View {
    @Bindable var model: CounterModel

    var body: some View {
        Section(header: Text("2.@Bindableで編集")) {
            TextField("名前", text: $model.name)
            Text("こんにちは、\(model.name) さん")
            Stepper("増減幅: \(model.step)", value: $model.step, in: 1...10)
        }
    }
}

private struct LearnerSection: View {
    @Environment(AppSettings.self) private var settings

    var body: some View {
        Section(header: Text("3.@Environmentで共有")) {
            Text("\(settings.learnerName) さんの実験室")

            if settings.showsHints {
                Text("「共有設定」で名前を変更すると、この表示にも反映されます。")
                    .font(.caption)
            }
        }
    }
}

private struct IgnoredPropertySection: View {
    @State private var refleshId = 0
    let model: CounterModel

    var body: some View {
        Section(header: Text("4.@ObservationIgnored")) {
            Text(model.debugNote)
                .id(refleshId)

            Button("① 通知せずに値を変更") {
                model.debugNote = "変更済み（通知なし）"
            }

            Button("② 表示を作り直して値を確認") {
                refleshId += 1
            }

            Text("①だけでは通知されません。②で表示を作り直すと変更後の値が見えます。他の理由で再描画された場合にも最新値が表示されることがあります。")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CounterLessonViewCopy().environment(AppSettings())
}
