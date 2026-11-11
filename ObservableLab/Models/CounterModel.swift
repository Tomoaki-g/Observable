import Observation

// @Observable は Observation のマクロ。@Published は不要。
@Observable
final class CounterModel {
    var count = 0
    var name = "SwiftUI"
    var step = 3
    var target = 10

    // この値を変えても、それ自体では View の更新を通知しない。
    @ObservationIgnored var debugNote = "まだ変更していません"

    // 計算プロパティの内部で読んだ count も追跡される。
    var status: String {
        count == 0 ? "まずは + ボタンを押してみましょう" : "現在のカウントは \(count) です"
    }

    func increment() { count += step }
    func decrement() { count -= step }
    func reset() { count = 0 }
    func isTargetReached() -> Bool { return count >= target }
}
