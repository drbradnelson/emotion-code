import XCTest
@testable import EmotionCode

final class ViewRowHeadersTests: XCTestCase {

    func testFramesCount() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 100)

            let view = try! Module.view(for: model)

            XCTAssertEqual(view.rowHeaderFrames.count, 2)
        }
    }

    func testSizesForSmallViewSize() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 100)

            let view = try! Module.view(for: model)

            let expectedSize = Size(
                width: 30,     // header size
                height: 30 * 2 // item height * 2
            )
            XCTAssertEqual(view.rowHeaderFrames[0].size, expectedSize)
            XCTAssertEqual(view.rowHeaderFrames[1].size, expectedSize)
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
                width: 200,
                height: 554 // minimum view height for compact layout
            )

            let view = try! Module.view(for: model)

            let totalExpectedVerticalSpace = Float(0
                + 10 * 2 // content padding
                + 30     // column header
                + 5 * 2  // section spacing
            )
            let expectedRowHeight = (554 - totalExpectedVerticalSpace) / 2 // (view height - total expected vertical space) / number of rows

            let expectedSize = Size(
                width: 30, // header size
                height: expectedRowHeight
            )
            XCTAssertEqual(view.rowHeaderFrames[0].size, expectedSize)
            XCTAssertEqual(view.rowHeaderFrames[1].size, expectedSize)
        }
    }

    func testOriginsForSmallViewSize() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 100)

            let view = try! Module.view(for: model)

            let expectedX: Float = 10 // content padding

            let expectedY1 = Float(0
                + 10 // content padding
                + 30 // column header
                + 5  // section spacing
            )
            let expectedY2 = Float(0
                + expectedY1
                + 30 * 2 // item height * 2
                + 5      // section spacing
            )

            XCTAssertEqual(view.rowHeaderFrames[0].origin, Point(x: expectedX, y: expectedY1))
            XCTAssertEqual(view.rowHeaderFrames[1].origin, Point(x: expectedX, y: expectedY2))
        }
    }

    func testOriginsForBigViewSize() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(
                width: 200,
                height: 554 // minimum view height for compact layout
            )

            let view = try! Module.view(for: model)

            let totalExpectedVerticalSpace = Float(0
                + 10 * 2 // content padding
                + 30     // column header
                + 5 * 2  // section spacing
            )
            let expectedRowHeight = (554 - totalExpectedVerticalSpace) / 2 // (view height - total expected vertical space) / number of columns

            let expectedX: Float = 10 // content padding

            let expectedY1 = Float(0
                + 10 // content padding
                + 30 // column header
                + 5  // section spacing
            )
            let expectedY2 = Float(0
                + expectedY1
                + expectedRowHeight
                + 5 // section spacing
            )

            XCTAssertEqual(view.rowHeaderFrames[0].origin, Point(x: expectedX, y: expectedY1))
            XCTAssertEqual(view.rowHeaderFrames[1].origin, Point(x: expectedX, y: expectedY2))
        }
    }

}
