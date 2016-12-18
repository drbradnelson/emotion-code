import XCTest
@testable import EmotionCode


final class ChartLayoutModuleViewTests: XCTestCase {

    func testView() {
        let model = Model()

        let view = Module.view(for: model)

        XCTAssertEqual(view.chartSize, .zero)
        XCTAssertNil(view.proposedVerticalContentOffset)
        XCTAssertTrue(view.itemFrames.isEmpty)
        XCTAssertTrue(view.columnHeaderFrames.isEmpty)
        XCTAssertEqual(View.numberOfColumns, 2)
    }

    func testViewItemFramesCount() {

        func test(itemsPerSection: Int...) {
            var model = Model()
            model.itemsPerSection = itemsPerSection

            let view = Module.view(for: model)

            XCTAssertEqual(view.itemFrames.count, model.itemsPerSection.count)

            for (section, itemsInSection) in itemsPerSection.enumerated() {
                XCTAssertEqual(view.itemFrames[section].count, itemsInSection)
            }
        }

        test(itemsPerSection: 0, 1, 2)
        test(itemsPerSection: 3, 4, 5, 6, 7)
        test(itemsPerSection: 8, 9)
    }

}
