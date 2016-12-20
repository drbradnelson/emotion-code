import XCTest
@testable import EmotionCode

final class ViewRowHeadersTests: XCTestCase {

    func testFramesCount() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]

        let view = Module.view(for: model)

        XCTAssertEqual(view.rowHeaderFrames.count, 3)
    }

    func testSizes() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]

        let view = Module.view(for: model)

        let expectedSize = Size(width: 30, height: 150)
        XCTAssertEqual(view.rowHeaderFrames[0].size, expectedSize)
        XCTAssertEqual(view.rowHeaderFrames[1].size, expectedSize)
        XCTAssertEqual(view.rowHeaderFrames[2].size, expectedSize)
    }

    func testOrigins() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]

        let view = Module.view(for: model)

        XCTAssertEqual(view.rowHeaderFrames[0].origin, Point(x: 10, y: 45))
        XCTAssertEqual(view.rowHeaderFrames[1].origin, Point(x: 10, y: 200))
        XCTAssertEqual(view.rowHeaderFrames[2].origin, Point(x: 10, y: 355))
    }

}
