import XCTest
@testable import EmotionCode

final class ViewChartSizeTests: XCTestCase {

    func testModeAll() {
        var model = Model()
        model.itemsPerSection = [1, 2, 3, 4, 5]
        let viewSize = Size(width: 123, height: 456)
        model.viewSize = viewSize

        let view = Module.view(for: model)

        let width = viewSize.width
        let lastRowHeaderFrame = view.rowHeaderFrames.last!
        let height = lastRowHeaderFrame.maxY + model.contentPadding
        let expectedSize = Size(width: width, height: height)
        XCTAssertEqual(view.chartSize, expectedSize)
    }

    func testModeSection() {
        var model = Model()
        model.mode = .section(0)
        model.itemsPerSection = [1, 2, 3, 4, 5]
        let viewSize = Size(width: 123, height: 456)
        model.viewSize = viewSize

        let view = Module.view(for: model)

        let lastColumnHeaderFrame = view.columnHeaderFrames.last!
        let width = lastColumnHeaderFrame.maxX + model.contentPadding
        let lastRowHeaderFrame = view.rowHeaderFrames.last!
        let height = lastRowHeaderFrame.maxY + model.contentPadding
        let expectedSize = Size(width: width, height: height)
        XCTAssertEqual(view.chartSize, expectedSize)
    }

    func testModeEmotion() {
        var model = Model()
        let indexPath = IndexPath(item: 0, section: 1)
        model.mode = .emotion(indexPath)
        model.itemsPerSection = [1, 2, 3, 4, 5]
        let viewSize = Size(width: 123, height: 456)
        model.viewSize = viewSize

        let view = Module.view(for: model)

        let width = view.columnHeaderFrames.last!.maxX + model.contentPadding
        let height = view.rowHeaderFrames.last!.maxY + model.contentPadding
        let expectedSize = Size(width: width, height: height)
        XCTAssertEqual(view.chartSize, expectedSize)
    }

}
