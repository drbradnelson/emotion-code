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

            let expectedSize = Size(width: 20, height: 30)
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
            model.viewSize = Size(width: 100, height: 554)

            let view = try! Module.view(for: model)

            let totalSpace = Float(0
                + 10 * 2 // content padding
                + 30 // row header
                + 5 * 2 // section spacing
            )
            let width = (Float(100) - totalSpace) / 2 // (view width - total space) / number of columns
            let expectedSize = Size(width: width, height: 30)
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
            let y: Float = 10 // content padding
            let x1 = Float(0
                + 10 // content padding
                + 30 // column header
                + 5  // section spacing
            )

            let totalHorizontalSpace = Float(0
                + 10 * 2 // content padding
                + 30 // row header
                + 5 * 2 // section spacing
            )
            let columnWidth = (Float(100) - totalHorizontalSpace) / 2 // (view width - total space) / number of columns

            let x2 = Float(x1
                + columnWidth
                + 5 // section spacing
            )

            XCTAssertEqual(view.columnHeaderFrames[0].origin, Point(x: x1, y: y))
            XCTAssertEqual(view.columnHeaderFrames[1].origin, Point(x: x2, y: y))
        }
    }

}
