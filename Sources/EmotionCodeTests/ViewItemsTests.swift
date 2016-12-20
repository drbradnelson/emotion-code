import XCTest
@testable import EmotionCode

final class ViewItemsTests: XCTestCase {

    func testCount() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3
        ]

        let view = Module.view(for: model)

        XCTAssertEqual(view.itemFrames.count, 3)

        XCTAssertEqual(view.itemFrames[0].count, 1)
        XCTAssertEqual(view.itemFrames[1].count, 2)
        XCTAssertEqual(view.itemFrames[2].count, 3)
    }

    func testSizesForSmallViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3
        ]
        model.viewSize = Size(width: 100, height: 100)

        let view = Module.view(for: model)

        let expectedSize = Size(width: 20, height: 30)

        XCTAssertEqual(view.itemFrames[0][0].size, expectedSize)

        XCTAssertEqual(view.itemFrames[1][0].size, expectedSize)
        XCTAssertEqual(view.itemFrames[1][1].size, expectedSize)

        XCTAssertEqual(view.itemFrames[2][0].size, expectedSize)
        XCTAssertEqual(view.itemFrames[2][1].size, expectedSize)
        XCTAssertEqual(view.itemFrames[2][2].size, expectedSize)
    }

    func testSizesForBigViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3
        ]
        model.viewSize = Size(width: 375, height: 300)

        let view = Module.view(for: model)

        let expectedSize = Size(width: 157.5, height: 40)

        XCTAssertEqual(view.itemFrames[0][0].size, expectedSize)

        XCTAssertEqual(view.itemFrames[1][0].size, expectedSize)
        XCTAssertEqual(view.itemFrames[1][1].size, expectedSize)

        XCTAssertEqual(view.itemFrames[2][0].size, expectedSize)
        XCTAssertEqual(view.itemFrames[2][1].size, expectedSize)
        XCTAssertEqual(view.itemFrames[2][2].size, expectedSize)
    }

    func testOriginsForSmallViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3
        ]
        model.viewSize = Size(width: 100, height: 100)

        let view = Module.view(for: model)

        XCTAssertEqual(view.itemFrames[0][0].origin, Point(x: 45, y: 45))

        XCTAssertEqual(view.itemFrames[1][0].origin, Point(x: 70, y: 45))
        XCTAssertEqual(view.itemFrames[1][1].origin, Point(x: 70, y: 75))

        XCTAssertEqual(view.itemFrames[2][0].origin, Point(x: 45, y: 140))
        XCTAssertEqual(view.itemFrames[2][1].origin, Point(x: 45, y: 170))
        XCTAssertEqual(view.itemFrames[2][2].origin, Point(x: 45, y: 200))
    }

    func testOriginsForBigViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3
        ]
        model.viewSize = Size(width: 375, height: 300)

        let view = Module.view(for: model)

        XCTAssertEqual(view.itemFrames[0][0].origin, Point(x: 45, y: 45))

        XCTAssertEqual(view.itemFrames[1][0].origin, Point(x: 207.5, y: 45))
        XCTAssertEqual(view.itemFrames[1][1].origin, Point(x: 207.5, y: 85))

        XCTAssertEqual(view.itemFrames[2][0].origin, Point(x: 45, y: 170))
        XCTAssertEqual(view.itemFrames[2][1].origin, Point(x: 45, y: 210))
        XCTAssertEqual(view.itemFrames[2][2].origin, Point(x: 45, y: 250))
    }

}
