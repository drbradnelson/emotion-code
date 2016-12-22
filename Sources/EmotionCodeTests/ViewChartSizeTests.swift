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
            let viewSize = Size(
                width: 100,
                height: 554 // minimular view height for compact layout
            )
            model.viewSize = viewSize

            let view = try! Module.view(for: model)

            XCTAssertEqual(view.chartSize, viewSize)
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

            let expectedWidth = Float(0
                + 20              // content padding
                + 30              // row header
                + 20              // section spacing
                + (200 - 20 - 20) // column 1
                + 20              // section spacing
                + (200 - 20 - 20) // column 2
                + 20              // content padding
            )
            let expectedHeight = Float(0
                + 20              // content padding
                + 30              // column header
                + 20              // section spacing
                + (300 - 20 - 20) // row 1
                + 20              // section spacing
                + (300 - 20 - 20) // row 2
                + 20              // content padding
            )
            XCTAssertEqual(view.chartSize, Size(width: expectedWidth, height: expectedHeight))
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

            let expectedWidth = Float(0
                + 20              // content padding
                + 30              // row header
                + 20              // section spacing
                + (200 - 20 - 20) // column 1
                + 20              // section spacing
                + (200 - 20 - 20) // column 2
                + 20              // content padding
            )
            let expectedHeight = Float(0
                + 20              // content padding
                + 30              // column header
                + 20              // section spacing
                + (300 - 20 - 20) // maximum section item 1
                + 20              // item spacing
                + (300 - 20 - 20) // maximum section item 2
                + 20              // section spacing
                + (300 - 20 - 20) // maximum section item 1
                + 20              // item spacing
                + (300 - 20 - 20) // maximum section item 2
                + 20              // content padding
            )
            XCTAssertEqual(view.chartSize, Size(width: expectedWidth, height: expectedHeight))
        }
    }

    func testViewSizeSmallerThanSectionSpacing() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(
            width: 0
            + 5  // section spacing
            - 1, // trigger
            height: 0
            + 5  // section spacing
        )

        XCTAssertThrowsError(try Module.view(for: model))
    }

    func testViewSizeSmallerThanContentPadding() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(
            width: 0
            + 10 // content padding
            - 1, // trigger
            height: 0
            + 10 // content padding
        )

        XCTAssertThrowsError(try Module.view(for: model))
    }

    func testViewSizeSmallerThanHeaderSize() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(
            width: 0
            + 30 // header size
            - 1, // trigger
            height: 0
            + 30 // header size
        )

        XCTAssertThrowsError(try Module.view(for: model))
    }

    func testViewWidthSmallerThanContentPaddingAndSectionSpacingAndRowHeaderWidth() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            2
        ]
        model.viewSize = Size(
            width: Float(0
                + 10 * 2 // content padding
                + 5 * 2  // section spacing
                + 30     // header size
                - 1      // trigger
            ),
            height: Float(0
                + 10 * 2 // content padding
                + 5 * 2  // section spacing
                + 30     // header size
            )
        )

        XCTAssertThrowsError(try Module.view(for: model))
    }

}
