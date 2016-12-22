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

            let totalExpectedHorizontalSpace = Float(0
                + 10 * 2 // content padding
                + 5 * 2  // section spacing
                + 30     // header size
            )
            let expectedSize = Size(
                width: (100 - totalExpectedHorizontalSpace) / 2, // (view width - total expected horizontal space) / number of columns
                height: 30                                       // header size
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
                height: 554 // minimum view height for compact layout
            )

            let view = try! Module.view(for: model)

            let totalExpectedSpace = Float(0
                + 10 * 2 // content padding
                + 30     // header
                + 5 * 2  // section spacing
            )

            let expectedSize = Size(
                width: (Float(200) - totalExpectedSpace) / 2, // (view width - total expected space) / number of rows
                height: (Float(554) - totalExpectedSpace) / 4 // (view width - total expected space) / number of items in column
            )

            XCTAssertEqual(view.itemFrames[0][0].size, expectedSize)

            XCTAssertEqual(view.itemFrames[1][0].size, expectedSize)
            XCTAssertEqual(view.itemFrames[1][1].size, expectedSize)

            XCTAssertEqual(view.itemFrames[2][0].size, expectedSize)
            XCTAssertEqual(view.itemFrames[2][1].size, expectedSize)
        }
    }

    func testXOriginsForSmallViewSize() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 100)

            let view = try! Module.view(for: model)

            let totalExpectedHorizontalSpace = Float(0
                + 10 * 2 // content padding
                + 30     // header
                + 5 * 2  // section spacing
            )
            let expectedItemWidth = (Float(100) - totalExpectedHorizontalSpace) / 2 // (view width - total expected horizontal space) / number of rows

            let expectedXForColumn1 = Float(0
                + 10 // content padding
                + 30 // row header
                + 5  // section spacing
            )
            let expectedXForColumn2 = Float(0
                + expectedXForColumn1
                + expectedItemWidth
                + 5 // section spacing
            )

            XCTAssertEqual(view.itemFrames[0][0].origin.x, expectedXForColumn1)

            XCTAssertEqual(view.itemFrames[1][0].origin.x, expectedXForColumn2)
            XCTAssertEqual(view.itemFrames[1][1].origin.x, expectedXForColumn2)

            XCTAssertEqual(view.itemFrames[2][0].origin.x, expectedXForColumn1)
            XCTAssertEqual(view.itemFrames[2][1].origin.x, expectedXForColumn1)
        }
    }

    func testYOriginsForSmallViewSize() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 100)

            let view = try! Module.view(for: model)

            let expectedYForRow1 = Float(0
                + 10 // content padding
                + 30 // column header
                + 5  // section spacing
            )
            let expectedYForRow1Item2 = Float(0
                + expectedYForRow1
                + 30 // item height
            )
            let expectedYForRow2 = Float(0
                + expectedYForRow1Item2
                + 30 // item height
                + 5  // section spacing
            )
            let expectedYForRow2Item2 = Float(0
                + expectedYForRow2
                + 30 // item height
            )

            XCTAssertEqual(view.itemFrames[0][0].origin.y, expectedYForRow1)

            XCTAssertEqual(view.itemFrames[1][0].origin.y, expectedYForRow1)
            XCTAssertEqual(view.itemFrames[1][1].origin.y, expectedYForRow1Item2)

            XCTAssertEqual(view.itemFrames[2][0].origin.y, expectedYForRow2)
            XCTAssertEqual(view.itemFrames[2][1].origin.y, expectedYForRow2Item2)
        }
    }

    func testXOriginsForBigViewSize() {
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

            let totalExpectedHorizontalSpace = Float(0
                + 10 * 2 // content padding
                + 30     // header
                + 5 * 2  // section spacing
            )
            let expectedItemWidth = (Float(200) - totalExpectedHorizontalSpace) / 2  // (view width - total expected horizontal space) / number of columns

            let expectedXForColumn1 = Float(0
                + 10 // content padding
                + 30 // row header
                + 5  // section spacing
            )
            let expectedXForColumn2 = Float(0
                + expectedXForColumn1
                + expectedItemWidth
                + 5 // section spacing
            )

            XCTAssertEqual(view.itemFrames[0][0].origin.x, expectedXForColumn1)

            XCTAssertEqual(view.itemFrames[1][0].origin.x, expectedXForColumn2)
            XCTAssertEqual(view.itemFrames[1][1].origin.x, expectedXForColumn2)

            XCTAssertEqual(view.itemFrames[2][0].origin.x, expectedXForColumn1)
            XCTAssertEqual(view.itemFrames[2][1].origin.x, expectedXForColumn1)
        }
    }

    func testYOriginsForBigViewSize() {
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
                + 30     // header
                + 5 * 2  // section spacing
            )
            let expectedItemHeight = (Float(554) - totalExpectedVerticalSpace) / 4 // (view height - total expected vertical space) / number of items in column

            let expectedYForRow1 = Float(0
                + 10 // content padding
                + 30 // column header
                + 5  // section spacing
            )
            let expectedYForRow1Item2 = Float(0
                + expectedYForRow1
                + expectedItemHeight
            )
            let expectedYForRow2 = Float(0
                + expectedYForRow1Item2
                + expectedItemHeight
                + 5 // section spacing
            )
            let expectedYForRow2Item2 = Float(0
                + expectedYForRow2
                + expectedItemHeight
            )

            XCTAssertEqual(view.itemFrames[0][0].origin.y, expectedYForRow1)

            XCTAssertEqual(view.itemFrames[1][0].origin.y, expectedYForRow1)
            XCTAssertEqual(view.itemFrames[1][1].origin.y, expectedYForRow1Item2)

            XCTAssertEqual(view.itemFrames[2][0].origin.y, expectedYForRow2)
            XCTAssertEqual(view.itemFrames[2][1].origin.y, expectedYForRow2Item2)
        }
    }

}
