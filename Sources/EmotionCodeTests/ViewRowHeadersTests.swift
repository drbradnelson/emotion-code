import XCTest
@testable import EmotionCode

final class ViewRowHeadersTests: XCTestCase {

    func testFramesCount() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(width: 100, height: 100)

        let view = try! Module.view(for: model)

        XCTAssertEqual(view.rowHeaderFrames.count, 2)
    }

    func testSizesForSmallViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(width: 100, height: 100)

        let view = try! Module.view(for: model)

        let height: Float = 30 * 2 // item height * 2
        let expectedSize = Size(width: 30, height: height)
        XCTAssertEqual(view.rowHeaderFrames[0].size, expectedSize)
        XCTAssertEqual(view.rowHeaderFrames[1].size, expectedSize)
    }

    func testSizesForBigViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(width: 200, height: 554)

        let view = try! Module.view(for: model)

        let totalSpace = Float(0
            + 10 * 2 // content padding
            + 30 // column header
            + 5 * 2  // section spacing
        )
        let height = (Float(554) - totalSpace) / Float(2) // (view width - all spacings) / number of rows

        let expectedSize = Size(width: 30, height: height)
        XCTAssertEqual(view.rowHeaderFrames[0].size, expectedSize)
        XCTAssertEqual(view.rowHeaderFrames[1].size, expectedSize)
    }

    func testOriginsForSmallViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = .zero

        let view = try! Module.view(for: model)

        XCTAssertEqual(view.rowHeaderFrames[0].origin, Point(x: 10, y: 45))
        XCTAssertEqual(view.rowHeaderFrames[1].origin, Point(x: 10, y: 200))
    }

    func testOriginsForBigViewSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(width: 375, height: 554)

        let view = try! Module.view(for: model)
        let x: Float = 10 // content padding
        let y1 = Float(0
            + 10 // content padding
            + 30 // column header
            + 5  // section spacing
        )

        let totalVerticalSpace = Float(0
            + 10 * 2 // content padding
            + 30 // column header
            + 5 * 2 // section spacing
        )
        let columnWidth = (Float(554) - totalVerticalSpace) / 2 // (view width - total space) / number of columns

        let y2 = Float(y1
            + columnWidth
            + 5 // section spacing
        )

        XCTAssertEqual(view.rowHeaderFrames[0].origin, Point(x: x, y: y1))
        XCTAssertEqual(view.rowHeaderFrames[1].origin, Point(x: x, y: y2))
    }

}
