import Observation
import XCTest
@testable import ObservableLab

final class CounterModelTests: XCTestCase {
    func testCounterUsesStepAndResets() {
        let model = CounterModel()
        model.step = 3
        model.increment()
        XCTAssertEqual(model.count, 3)
        model.decrement()
        XCTAssertEqual(model.count, 0)
        model.decrement()
        XCTAssertEqual(model.count, -3)
        model.reset()
        XCTAssertEqual(model.count, 0)
    }

    func testChangingCountNotifiesObserver() {
        let model = CounterModel()
        let changed = expectation(description: "count change")
        withObservationTracking {
            _ = model.count
        } onChange: {
            changed.fulfill()
        }
        model.increment()
        wait(for: [changed], timeout: 1)
    }

    func testUnrelatedAndIgnoredChangesDoNotNotify() {
        let model = CounterModel()
        let unrelated = expectation(description: "name is not a count dependency")
        unrelated.isInverted = true
        let ignored = expectation(description: "ignored property does not notify")
        ignored.isInverted = true
        withObservationTracking {
            _ = model.count
        } onChange: {
            unrelated.fulfill()
        }
        withObservationTracking {
            _ = model.debugNote
        } onChange: {
            ignored.fulfill()
        }
        model.name = "Observation"
        model.debugNote = "changed"
        wait(for: [unrelated, ignored], timeout: 0.1)
        XCTAssertEqual(model.debugNote, "changed")
    }

    func testComputedPropertyTracksItsDependency() {
        let model = CounterModel()
        let changed = expectation(description: "status depends on count")
        withObservationTracking {
            _ = model.status
        } onChange: {
            changed.fulfill()
        }
        model.increment()
        wait(for: [changed], timeout: 1)
        XCTAssertEqual(model.status, "現在のカウントは 1 です")
    }
}
