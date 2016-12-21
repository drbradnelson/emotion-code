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

        let view = try! Module.view(for: model)

        XCTAssertEqual(view.rowHeaderFrames.count, 3)
    }

    func testSizesForSmallViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.viewSize = .zero

        let view = try! Module.view(for: model)

        let expectedSize = Size(width: 30, height: 150)
        XCTAssertEqual(view.rowHeaderFrames[0].size, expectedSize)
        XCTAssertEqual(view.rowHeaderFrames[1].size, expectedSize)
        XCTAssertEqual(view.rowHeaderFrames[2].size, expectedSize)
    }

    func testSizesForBigViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.viewSize = Size(width: 375, height: 200)

        let view = try! Module.view(for: model)

        let expectedSize = Size(width: 30, height: 45)
        XCTAssertEqual(view.rowHeaderFrames[0].size, expectedSize)
        XCTAssertEqual(view.rowHeaderFrames[1].size, expectedSize)
        XCTAssertEqual(view.rowHeaderFrames[2].size, expectedSize)
    }

    func testOriginsForSmallViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.viewSize = .zero

        let view = try! Module.view(for: model)

        XCTAssertEqual(view.rowHeaderFrames[0].origin, Point(x: 10, y: 45))
        XCTAssertEqual(view.rowHeaderFrames[1].origin, Point(x: 10, y: 200))
        XCTAssertEqual(view.rowHeaderFrames[2].origin, Point(x: 10, y: 355))
    }

    func testOriginsForBigViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.viewSize = Size(width: 375, height: 200)

        let view = try! Module.view(for: model)

        XCTAssertEqual(view.rowHeaderFrames[0].origin, Point(x: 10, y: 45))
        XCTAssertEqual(view.rowHeaderFrames[1].origin, Point(x: 10, y: 95))
        XCTAssertEqual(view.rowHeaderFrames[2].origin, Point(x: 10, y: 145))
    }

}
