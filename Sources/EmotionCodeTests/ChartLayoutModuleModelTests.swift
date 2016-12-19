import XCTest
@testable import EmotionCode

final class ChartLayoutModuleModelTests: XCTestCase {

    func testModelContentPadding() {
        var model = Model()

        model.mode = .all
        XCTAssertEqual(model.contentPadding, 10)

        model.mode = .section(0)
        XCTAssertEqual(model.contentPadding, 20)

        model.mode = .emotion(IndexPath())
        XCTAssertEqual(model.contentPadding, 20)
    }

    func testModelSectionSpacing() {
        var model = Model()
        var expectedSectionSpacing: Size

        model.mode = .all
        expectedSectionSpacing = Size(width: 15, height: 15)
        XCTAssertEqual(model.sectionSpacing, expectedSectionSpacing)

        model.mode = .section(0)
        expectedSectionSpacing = Size(width: 15, height: 20)
        XCTAssertEqual(model.sectionSpacing, expectedSectionSpacing)

        model.mode = .emotion(IndexPath())
        expectedSectionSpacing = Size(width: 15, height: 20)
        XCTAssertEqual(model.sectionSpacing, expectedSectionSpacing)
    }

    func testModelItemSpacing() {
        var model = Model()

        model.mode = .all
        XCTAssertEqual(model.itemSpacing, 5)

        model.mode = .section(0)
        XCTAssertEqual(model.itemSpacing, 10)

        model.mode = .emotion(IndexPath())
        XCTAssertEqual(model.itemSpacing, 20)
    }

    func testModelSetModeToSection() {
        var model = Model()

        let mode = Mode.section(0)
        _ = Module.update(for: .setMode(mode), model: &model)

        var expectedModel = Model()
        expectedModel.mode = mode
        XCTAssertEqual(model, expectedModel)
    }

    func testModelSetModeToEmotion() {
        var model = Model()

        let mode = Mode.emotion(IndexPath())
        _ = Module.update(for: .setMode(mode), model: &model)

        var expectedModel = Model()
        expectedModel.mode = mode
        XCTAssertEqual(model, expectedModel)
    }

    func testModelSetItemsPerSection() {
        var model = Model()

        let itemsPerSection = [1, 2, 3]
        _ = Module.update(for: .setItemsPerSection(itemsPerSection), model: &model)

        var expectedModel = Model()
        expectedModel.itemsPerSection = itemsPerSection
        XCTAssertEqual(model, expectedModel)
    }

    func testModelSetViewSize() {
        var model = Model()

        let viewSize = Size(width: 12, height: 34)
        _ = Module.update(for: .setViewSize(viewSize), model: &model)

        var expectedModel = Model()
        expectedModel.viewSize = viewSize
        XCTAssertEqual(model, expectedModel)
    }

}
