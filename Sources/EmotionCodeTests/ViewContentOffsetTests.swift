import XCTest
@testable import EmotionCode

final class ViewContentOffsetTests: XCTestCase {

    func testModeSection0() {
        do {
            var model = Model()
            model.mode = .section(0)
            model.viewSize = Size(width: 200, height: 300)
            model.itemsPerSection = [
                1, 2,
                2
            ]

            let view = try! Module.view(for: model)

            XCTAssertEqual(view.proposedVerticalContentOffset, Float(0
                + 20 // content padding
                + 30 // column header
            ))
        }
    }

    func testModeSection2() {
        do {
            var model = Model()
            model.mode = .section(2)
            model.viewSize = Size(width: 200, height: 300)
            model.itemsPerSection = [
                1, 2,
                2
            ]

            let view = try! Module.view(for: model)

            XCTAssertEqual(view.proposedVerticalContentOffset, Float(0
                + 20 // content padding
                + 30 // column header
                + 20 // section spacing
                + (300 - 20 - 20) // row 1
            ))
        }
    }

    func testModeEmotionIndexPath() {
        do {
            var model = Model()
            model.mode = .emotion(IndexPath.arbitrary)
            model.viewSize = Size(width: 200, height: 300)
            model.itemsPerSection = [
                1, 2,
                2
            ]

            let view = try! Module.view(for: model)

            XCTAssertEqual(view.proposedVerticalContentOffset, Float(0
                + 20 // content padding
                + 30 // column header
                + 20 // section spacing
                + (300 - 20 - 20) // maximum section item 1
                + 20 // item spacing
                + (300 - 20 - 20) // maximum section item 2
                + 20 // section spacing
                + (300 - 20 - 20) // maximum section item 1
            ))
        }
    }

}
