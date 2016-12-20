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

    func testSizes() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.viewSize = Size(width: 100, height: 100)

        let view = Module.view(for: model)

        let expectedSize = Size(width: 10, height: 30)
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

        let firstOrigin = Point(x: 55, y: 10)
        let secondOrigin = Point(x: 80, y: 10)

        XCTAssertEqual(view.columnHeaderFrames[0].origin, firstOrigin)
        XCTAssertEqual(view.columnHeaderFrames[1].origin, secondOrigin)
    }

}
