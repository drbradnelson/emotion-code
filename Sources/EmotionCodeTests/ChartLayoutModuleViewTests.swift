import XCTest
@testable import EmotionCode


final class ChartLayoutModuleViewTests: XCTestCase {

    func testViewNumberOfColumns() {
        XCTAssertEqual(View.numberOfColumns, 2)
    }

    func testViewChartSizeWhenNoItems() {
        let model = Model()

        let view = Module.view(for: model)

        XCTAssertEqual(view.chartSize, .zero)
    }

    func testViewItemFramesCount() {

        func test(itemsPerSection: Int...) {
            var model = Model()
            model.itemsPerSection = itemsPerSection

            let view = Module.view(for: model)

            XCTAssertEqual(view.itemFrames.count, model.itemsPerSection.count)

            for (section, itemsCount) in itemsPerSection.enumerated() {
                XCTAssertEqual(view.itemFrames[section].count, itemsCount)
            }
        }

        test(itemsPerSection: 0)
        test(itemsPerSection: 1, 2)
        test(itemsPerSection: 3, 4, 5)
        test(itemsPerSection: 6, 7, 8, 9)

    }

    func testViewColumnHeadersFramesCount() {

        func test(sectionsCount: Int) {
            var model = Model()
            model.itemsPerSection = Array(repeating: 0, count: sectionsCount)

            let view = Module.view(for: model)

            if sectionsCount > 0 {
                XCTAssertEqual(view.columnHeaderFrames.count, View.numberOfColumns)
            } else {
                XCTAssertEqual(view.columnHeaderFrames.count, 0)
            }
        }

        test(sectionsCount: 0)
        test(sectionsCount: 1)
        test(sectionsCount: 2)
        test(sectionsCount: 3)

    }

    func testViewRowHeaderFramesCount() {

        func test(sectionsCount: Int) {
            var model = Model()
            model.itemsPerSection = Array(repeating: 0, count: sectionsCount)

            let view = Module.view(for: model)

            let expectedRowCount = (Float(sectionsCount) / Float(View.numberOfColumns)).rounded(.up)
            XCTAssertEqual(view.rowHeaderFrames.count, Int(expectedRowCount))
        }

        test(sectionsCount: 0)
        test(sectionsCount: 1)
        test(sectionsCount: 2)
        test(sectionsCount: 3)

    }

}
