import XCTest
@testable import EmotionCode

final class ViewItemsTests: XCTestCase {

    func testCount() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 200)

            let view = try! Module.view(for: model)

            XCTAssertEqual(view.itemFrames.count, 3)

            XCTAssertEqual(view.itemFrames[0].count, 1)
            XCTAssertEqual(view.itemFrames[1].count, 2)
            XCTAssertEqual(view.itemFrames[2].count, 2)
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

            let totalHorizontalSpace = Float(0
                + 10 * 2 // content padding
                + 5 * 2  // section spacing
                + 30     // headerSize
            )
            let expectedSize = Size(
                width: (100 - totalHorizontalSpace) / 2, // (view width - total horizontal space) / number of columns
                height: 30
            )

            XCTAssertEqual(view.itemFrames[0][0].size, expectedSize)

            XCTAssertEqual(view.itemFrames[1][0].size, expectedSize)
            XCTAssertEqual(view.itemFrames[1][1].size, expectedSize)

            XCTAssertEqual(view.itemFrames[2][0].size, expectedSize)
            XCTAssertEqual(view.itemFrames[2][1].size, expectedSize)
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
                height: 554 // Module.minViewHeightForCompactLayout
            )

            let view = try! Module.view(for: model)

            let totalSpace = Float(0
                + 10 * 2 // content padding
                + 30     // header
                + 5 * 2  // section spacing
            )

            let expectedSize = Size(
                width: (Float(200) - totalSpace) / 2, // (view width - total space) / number of rows
                height: (Float(554) - totalSpace) / 4 // (view width - total space) / number of items in column
            )

            XCTAssertEqual(view.itemFrames[0][0].size, expectedSize)

            XCTAssertEqual(view.itemFrames[1][0].size, expectedSize)
            XCTAssertEqual(view.itemFrames[1][1].size, expectedSize)

            XCTAssertEqual(view.itemFrames[2][0].size, expectedSize)
            XCTAssertEqual(view.itemFrames[2][1].size, expectedSize)
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

            let totalSpace = Float(0
                + 10 * 2 // content padding
                + 30     // header
                + 5 * 2  // section spacing
            )
            let itemWidth = (Float(100) - totalSpace) / 2 // (view width - total space) / number of rows

            let column1x = Float(0
                + 10 // content padding
                + 30 // row header
                + 5  // section spacing
            )
            let column2x = Float(0
                + column1x
                + itemWidth
                + 5 // section spacing
            )

            let row1y = Float(0
                + 10 // content padding
                + 30 // column header
                + 5  // section spacing
            )

            let row1item2y = Float(0
                + row1y
                + 30 // item height
            )

            let row2y = Float(0
                + row1item2y
                + 30 // item height
                + 5  // section spacing
            )

            let row2item2y = Float(0
                + row2y
                + 30 // item height
            )

            XCTAssertEqual(view.itemFrames[0][0].origin, Point(x: column1x, y: row1y))

            XCTAssertEqual(view.itemFrames[1][0].origin, Point(x: column2x, y: row1y))
            XCTAssertEqual(view.itemFrames[1][1].origin, Point(x: column2x, y: row1item2y))

            XCTAssertEqual(view.itemFrames[2][0].origin, Point(x: column1x, y: row2y))
            XCTAssertEqual(view.itemFrames[2][1].origin, Point(x: column1x, y: row2item2y))
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
                height: 554 // Module.minViewHeightForCompactLayout
            )

            let view = try! Module.view(for: model)

            let totalSpace = Float(0
                + 10 * 2 // content padding
                + 30     // header
                + 5 * 2  // section spacing
            )
            let itemWidth = (Float(200) - totalSpace) / 2  // (view width - total space) / number of columns
            let itemHeight = (Float(554) - totalSpace) / 4 // (view height - total space) / number of items in column

            let column1x = Float(0
                + 10 // content padding
                + 30 // row header
                + 5  // section spacing
            )

            let column2x = Float(0
                + column1x
                + itemWidth
                + 5 // section spacing
            )

            let row1y = Float(0
                + 10 // contentPadding
                + 30 // column header
                + 5  // section spacing
            )

            let row1item2y = Float(0
                + row1y
                + itemHeight
            )

            let row2y = Float(0
                + row1item2y
                + itemHeight
                + 5 // section spacing
            )

            let row2item2y = Float(0
                + row2y
                + itemHeight
            )

            XCTAssertEqual(view.itemFrames[0][0].origin, Point(x: column1x, y: row1y))

            XCTAssertEqual(view.itemFrames[1][0].origin, Point(x: column2x, y: row1y))
            XCTAssertEqual(view.itemFrames[1][1].origin, Point(x: column2x, y: row1item2y))

            XCTAssertEqual(view.itemFrames[2][0].origin, Point(x: column1x, y: row2y))
            XCTAssertEqual(view.itemFrames[2][1].origin, Point(x: column1x, y: row2item2y))
        }
    }

}
