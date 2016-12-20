import XCTest
@testable import EmotionCode

final class ViewFramesCountTests: XCTestCase {

    func testItemFrames() {
        var model = Model()
        model.itemsPerSection = [
            0, 1,
            2, 3,
            4
        ]

        let view = Module.view(for: model)

        XCTAssertEqual(view.itemFrames.count, 5)
    }

    func testItemFramesPerSection() {
        var model = Model()
        model.itemsPerSection = [
            0, 1,
            2, 3,
            4
        ]

        let view = Module.view(for: model)

        XCTAssertEqual(view.itemFrames[0].count, 0)
        XCTAssertEqual(view.itemFrames[1].count, 1)
        XCTAssertEqual(view.itemFrames[2].count, 2)
        XCTAssertEqual(view.itemFrames[3].count, 3)
        XCTAssertEqual(view.itemFrames[4].count, 4)
    }

    func testRowHeaderFrames() {
        var model = Model()
        model.itemsPerSection = [
            0, 1,
            2, 3,
            4
        ]

        let view = Module.view(for: model)

        XCTAssertEqual(view.rowHeaderFrames.count, 3)
    }

}
