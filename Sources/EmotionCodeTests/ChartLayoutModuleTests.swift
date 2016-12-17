import Foundation
import XCTest
@testable import EmotionCode

typealias Module = ChartLayoutModule
typealias Mode = Module.Mode
typealias Message = Module.Message
typealias Model = Module.Model
typealias View = Module.View

final class ChartLayoutModuleTests: XCTestCase {

    func testModel() {
        let model = Model()
        XCTAssertTrue(model.mode == .all)
        XCTAssertTrue(model.itemsPerSection.isEmpty)
        XCTAssertTrue(model.viewSize == .zero)
    }

    func testDidSetModelModeToEmotion() {
        var model = Model()
        model.mode = .all

        let mode = Mode.emotion(IndexPath())
        _ = Module.update(for: .setMode(mode), model: &model)

        var expectedModel = Model()
        expectedModel.mode = mode
        XCTAssertTrue(model == expectedModel)
    }

    func testDidSetModelModeToSection() {
        var model = Model()
        model.mode = .all

        let mode = Mode.section(0)
        _ = Module.update(for: .setMode(mode), model: &model)

        var expectedModel = Model()
        expectedModel.mode = mode
        XCTAssertTrue(model == expectedModel)
    }

    func testDidSetItemsPerSection() {
        var model = Model()
        model.itemsPerSection = []

        let itemsPerSection = [1, 2, 3]
        _ = Module.update(for: .setItemsPerSection(itemsPerSection), model: &model)

        var expectedModel = Model()
        expectedModel.itemsPerSection = itemsPerSection
        XCTAssertTrue(model == expectedModel)
    }

    func testDidSetViewSize() {
        var model = Model()
        model.viewSize = .zero

        let viewSize = Size(width: 12, height: 34)
        _ = Module.update(for: .setViewSize(viewSize), model: &model)

        var expectedModel = Model()
        expectedModel.viewSize = viewSize
        XCTAssertTrue(model == expectedModel)
    }

}

private extension Mode {
    static func ==(lhs: Mode, rhs: Mode) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

private extension Size {
    static func ==(lhs: Size, rhs: Size) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

private extension Model {
    static func ==(lhs: Model, rhs: Model) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
