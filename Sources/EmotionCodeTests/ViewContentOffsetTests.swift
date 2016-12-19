import XCTest
@testable import EmotionCode

final class ViewContentOffsetTests: XCTestCase {

    func testModeSection0() {
        var model = Model()
        let section = 0
        model.mode = .section(section)

        let itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.itemsPerSection = itemsPerSection

        let view = Module.view(for: model)

        let expectedVerticalContentOffset = view.itemFrames[section][0].origin.y - model.sectionSpacing.height
        XCTAssertEqual(view.proposedVerticalContentOffset, expectedVerticalContentOffset)
    }

    func testModeSection1() {
        var model = Model()
        let section = 1
        model.mode = .section(section)

        let itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.itemsPerSection = itemsPerSection

        let view = Module.view(for: model)

        let expectedVerticalContentOffset = view.itemFrames[section][0].origin.y - model.sectionSpacing.height
        XCTAssertEqual(view.proposedVerticalContentOffset, expectedVerticalContentOffset)
    }

    func testModeEmotionIndexPath01() {
        var model = Model()
        let item = 0
        let section = 1
        model.mode = .emotion(IndexPath(item: item, section: section))

        let itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.itemsPerSection = itemsPerSection

        let view = Module.view(for: model)

        let expectedVerticalContentOffset = view.itemFrames[section][item].origin.y - model.itemSpacing
        XCTAssertEqual(view.proposedVerticalContentOffset, expectedVerticalContentOffset)
    }

    func testModeEmotionIndexPath23() {
        var model = Model()
        let item = 2
        let section = 3
        model.mode = .emotion(IndexPath(item: item, section: section))

        let itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.itemsPerSection = itemsPerSection

        let view = Module.view(for: model)

        let expectedVerticalContentOffset = view.itemFrames[section][item].origin.y - model.itemSpacing
        XCTAssertEqual(view.proposedVerticalContentOffset, expectedVerticalContentOffset)
    }

}
