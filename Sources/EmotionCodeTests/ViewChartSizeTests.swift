import XCTest
@testable import EmotionCode

final class ViewChartSizeTests: XCTestCase {

    func testModeAll() {
        var model = Model()
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        let viewSize = Size(width: 100, height: 200)
        model.viewSize = viewSize

        let view = Module.view(for: model)

        let expectedSize = Size(width: 100, height: 515)
        XCTAssertEqual(view.chartSize, expectedSize)
    }

    func testModeSection() {
        var model = Model()
        model.mode = .section(0)
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        let viewSize = Size(width: 100, height: 100)
        model.viewSize = viewSize

        let view = Module.view(for: model)


        let expectedSize = Size(width: 210, height: 310)
        XCTAssertEqual(view.chartSize, expectedSize)
    }

    func testModeEmotion() {
        var model = Model()
        let indexPath = IndexPath(item: 0, section: 1)
        model.mode = .emotion(indexPath)
        model.itemsPerSection = [
            1, 2,
            3, 4,
            5
        ]
        let viewSize = Size(width: 100, height: 100)
        model.viewSize = viewSize

        let view = Module.view(for: model)

        let expectedSize = Size(width: 210, height: 1270)
        XCTAssertEqual(view.chartSize, expectedSize)
    }

}
