import XCTest
@testable import EmotionCode

final class SimpleModelTests: XCTestCase {

    func testSetMode() {
        var model = Model()

        _ = Module.update(for: .setMode(.section(0)), model: &model)
        XCTAssertEqual(model.mode, .section(0))

        _ = Module.update(for: .setMode(.emotion(IndexPath())), model: &model)
        XCTAssertEqual(model.mode, .emotion(IndexPath()))

        _ = Module.update(for: .setMode(.all), model: &model)
        XCTAssertEqual(model.mode, .all)
    }

    func testSetItemsPerSection() {
        var model = Model()

        let itemsPerSection = [0, 1, 2, 3, 4]
        _ = Module.update(for: .setItemsPerSection(itemsPerSection), model: &model)

        XCTAssertEqual(model.itemsPerSection, itemsPerSection)
    }

    func testSetViewSize() {
        var model = Model()

        let size = Size(width: 123, height: 456)
        _ = Module.update(for: .setViewSize(size), model: &model)

        XCTAssertEqual(model.viewSize, size)
    }

}
