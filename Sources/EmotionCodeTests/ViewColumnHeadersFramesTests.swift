import XCTest
@testable import EmotionCode

final class ViewColumnHeadersTests: XCTestCase {

    func testFramesCount() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]

        let view = Module.view(for: model)

        XCTAssertEqual(view.columnHeaderFrames.count, 2)
    }

    func testSizesForSmallViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.viewSize = Size(width: 100, height: 0)

        let view = Module.view(for: model)

        let expectedSize = Size(width: 20, height: 30)
        XCTAssertEqual(view.columnHeaderFrames[0].size, expectedSize)
        XCTAssertEqual(view.columnHeaderFrames[1].size, expectedSize)
    }

    func testSizesForBigViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.viewSize = Size(width: 375, height: 0)

        let view = Module.view(for: model)

        let expectedSize = Size(width: 157.5, height: 30)
        XCTAssertEqual(view.columnHeaderFrames[0].size, expectedSize)
        XCTAssertEqual(view.columnHeaderFrames[1].size, expectedSize)
    }

    func testOrigins() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.viewSize = Size(width: 100, height: 100)

        let view = Module.view(for: model)

        XCTAssertEqual(view.columnHeaderFrames[0].origin, Point(x: 45, y: 10))
        XCTAssertEqual(view.columnHeaderFrames[1].origin, Point(x: 70, y: 10))
    }

}
