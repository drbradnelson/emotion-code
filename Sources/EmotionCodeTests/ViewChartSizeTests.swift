import XCTest
@testable import EmotionCode

final class ViewChartSizeTests: XCTestCase {

    func testModeAllForSmallViewSize() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 200)

            let view = try! Module.view(for: model)

            XCTAssertEqual(view.chartSize, Size(width: 100, height: Float(0
                + 10      // content padding
                + 30      // column header
                + 5       // section spacing
                + 30 * 2  // row 1
                + 5       // section spacing
                + 30 * 2  // row 2
                + 10      // content padding
            )))
        }
    }

    func testModeAllForBigViewSize() {
        do {
            var model = Model()
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 100, height: 554)

            let view = try! Module.view(for: model)

            XCTAssertEqual(view.chartSize, Size(width: 100, height: 554))
        }
    }

    func testModeSection() {
        do {
            var model = Model()
            model.mode = .section(0)
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 200, height: 300)

            let view = try! Module.view(for: model)

            let width = Float(0
                + 20  // content padding
                + 30  // row header
                + 20  // section spacing
                + (200 - 20 - 20) // column 1
                + 20  // section spacing
                + (200 - 20 - 20) // column 2
                + 20  // contentPadding
            )
            let height = Float(0
                + 20  // content padding
                + 30  // column header
                + 20  // section spacing
                + (300 - 20 - 20) // row 1
                + 20  // section spacing
                + (300 - 20 - 20) // row 2
                + 20  // content padding
            )
            XCTAssertEqual(view.chartSize, Size(width: width, height: height))
        }
    }

    func testModeEmotion() {
        do {
            var model = Model()
            model.mode = .emotion(IndexPath.arbitrary)
            model.itemsPerSection = [
                1, 2,
                2
            ]
            model.viewSize = Size(width: 200, height: 300)

            let view = try! Module.view(for: model)

            let width = Float(0
                + 20  // content padding
                + 30  // row header
                + 20  // section spacing
                + (200 - 20 - 20) // column 1
                + 20  // section spacing
                + (200 - 20 - 20) // column 2
                + 20  // contentPadding
            )
            let height = Float(0
                + 20  // content padding
                + 30  // column header
                + 20  // section spacing
                + (300 - 20 - 20) // maximum section item 1
                + 20  // item spacing
                + (300 - 20 - 20) // maximum section item 2
                + 20  // section spacing
                + (300 - 20 - 20) // maximum section item 1
                + 20  // item spacing
                + (300 - 20 - 20) // maximum section item 2
                + 20  // contentPadding
            )
            XCTAssertEqual(view.chartSize, Size(width: width, height: height))
        }
    }

    func testViewSizeSmallerThanSectionSpacing() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(width: 1, height: 2)

        XCTAssertThrowsError(try Module.view(for: model))
    }

    func testViewSizeSmallerThanContentPadding() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(width: 6, height: 7)

        XCTAssertThrowsError(try Module.view(for: model))
    }

    func testViewSizeSmallerThanHeaderSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(width: 29, height: 29)

        XCTAssertThrowsError(try Module.view(for: model))
    }

    func viewWidthSmallerThanAllSpacingAndRowHeaderWidth() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(width: 31, height: 32)

        XCTAssertThrowsError(try Module.view(for: model))
    }

}
