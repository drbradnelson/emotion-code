import XCTest
@testable import EmotionCode

final class ViewContentOffsetTests: XCTestCase {

    func testModeSection0() {
        var model = Model()
        let section = 0
        model.mode = .section(section)
        model.viewSize = Size(width: 0, height: 100)

        let itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.itemsPerSection = itemsPerSection

        let view = Module.view(for: model)

        XCTAssertEqual(view.proposedVerticalContentOffset, 50)
    }

    func testModeSection2() {
        var model = Model()
        let section = 2
        model.mode = .section(section)
        model.viewSize = Size(width: 0, height: 100)

        let itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.itemsPerSection = itemsPerSection

        let view = Module.view(for: model)

        XCTAssertEqual(view.proposedVerticalContentOffset, 130)
    }

    func testModeEmotionIndexPath01() {
        var model = Model()
        let item = 0
        let section = 1
        model.mode = .emotion(IndexPath(item: item, section: section))
        model.viewSize = Size(width: 0, height: 100)

        let itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.itemsPerSection = itemsPerSection

        let view = Module.view(for: model)

        XCTAssertEqual(view.proposedVerticalContentOffset, 50)
    }

    func testModeEmotionIndexPath23() {
        var model = Model()
        let item = 2
        let section = 3
        model.mode = .emotion(IndexPath(item: item, section: section))
        model.viewSize = Size(width: 0, height: 100)

        let itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        model.itemsPerSection = itemsPerSection

        let view = Module.view(for: model)

        print(view.itemFrames[1])
        print(view.itemFrames[3])

        XCTAssertEqual(view.proposedVerticalContentOffset, 610)
    }

}
