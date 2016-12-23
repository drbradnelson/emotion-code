import XCTest
@testable import EmotionCode

final class ViewColumnHeadersTests: XCTestCase {

    func testFramesCount() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 100)

            let view = try! Module.view(for: model)

            XCTAssertEqual(view.columnHeaderFrames.count, 2)
        }
    }

    func testSizesForSmallViewSize() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 200)

            let view = try! Module.view(for: model)

            let totalExpectedHorizontalSpace = Float(0
                + 10 * 2 // content padding
                + 5 * 2  // section spacing
                + 30     // header size
            )
            let expectedColumnWidth = (100 - totalExpectedHorizontalSpace) / 2 // (view width - total expected horizontal space) / number of columns

            let expectedSize = Size(
                width: expectedColumnWidth,
                height: 30 // header size
            )
            XCTAssertEqual(view.columnHeaderFrames[0].size, expectedSize)
            XCTAssertEqual(view.columnHeaderFrames[1].size, expectedSize)
        }
    }

    func testSizesForBigViewSize() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(
                width: 100,
                height: 554 // minimum view height for compact layout
            )

            let view = try! Module.view(for: model)

            let totalExpectedHorizontalSpace = Float(0
                + 10 * 2 // content padding
                + 30     // row header
                + 5 * 2  // section spacing
            )

            let expectedColumnHeight = (100 - totalExpectedHorizontalSpace) / 2 // (view width - total expected horizontal space) / number of columns

            let expectedSize = Size(
                width: expectedColumnHeight,
                height: 30 // header size
            )
            XCTAssertEqual(view.columnHeaderFrames[0].size, expectedSize)
            XCTAssertEqual(view.columnHeaderFrames[1].size, expectedSize)
        }
    }

    func testOrigins() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 100)

            let view = try! Module.view(for: model)

            let expectedY: Float = 10 // content padding
            let expectedX1 = Float(0
                + 10 // content padding
                + 30 // column header
                + 5  // section spacing
            )

            let totalExpectedHorizontalSpace = Float(0
                + 10 * 2 // content padding
                + 30     // row header
                + 5 * 2  // section spacing
            )
            let expectedColumnHeight = (100 - totalExpectedHorizontalSpace) / 2 // (view width - total expected horizontal space) / number of columns

            let expectedX2 = Float(0
                + expectedX1
                + expectedColumnHeight
                + 5 // section spacing
            )

            XCTAssertEqual(view.columnHeaderFrames[0].origin, Point(x: expectedX1, y: expectedY))
            XCTAssertEqual(view.columnHeaderFrames[1].origin, Point(x: expectedX2, y: expectedY))
        }
    }

}
