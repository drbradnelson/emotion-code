import XCTest
@testable import EmotionCode

final class ChartLayoutModuleViewTests: XCTestCase {

    func testViewNumberOfColumns() {
        XCTAssertEqual(View.numberOfColumns, 2)
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

    func testViewProposedVerticalContentOffsetModeAll() {
        let model = Model()

        let view = Module.view(for: model)

        XCTAssertNil(view.proposedVerticalContentOffset)
    }

    func testViewProposedVerticalContentOffsetModeSection() {

        func test(section: Int, itemsPerSection: Int...) {
            var model = Model()
            model.mode = .section(section)
            model.itemsPerSection = itemsPerSection

            let view = Module.view(for: model)

            let expectedVerticalContentOffset = view.itemFrames[section][0].origin.y - model.sectionSpacing.height
            XCTAssertEqual(view.proposedVerticalContentOffset, expectedVerticalContentOffset)
        }

        test(section: 0, itemsPerSection: 1)
        test(section: 1, itemsPerSection: 2, 3)
        test(section: 2, itemsPerSection: 4, 5, 6)
        test(section: 3, itemsPerSection: 7, 8, 9, 10)

    }

    func testViewProposedVerticalContentOffsetModeEmotion() {

        func test(item: Int, section: Int, itemsPerSection: Int...) {
            var model = Model()
            model.mode = .emotion(IndexPath(item: item, section: section))
            model.itemsPerSection = itemsPerSection

            let view = Module.view(for: model)

            let expectedVerticalContentOffset = view.itemFrames[section][item].origin.y - model.itemSpacing
            XCTAssertEqual(view.proposedVerticalContentOffset, expectedVerticalContentOffset)
        }

        test(item: 0, section: 1, itemsPerSection: 1, 2)
        test(item: 1, section: 2, itemsPerSection: 3, 4 ,5)
        test(item: 2, section: 3, itemsPerSection: 6, 7, 8, 9)
    }

}
