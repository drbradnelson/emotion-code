import XCTest
@testable import EmotionCode

final class MessagesModelTests: XCTestCase {

    func testSetMode() {
        do {
            var model = Model()
            let commands = try! Module.update(for: .setMode(.section(0)), model: &model)
            XCTAssertEqual(model, Model(mode: .section(0)))
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setMode(.emotion(IndexPath.arbitrary)), model: &model)
            XCTAssertEqual(model, Model(mode: .emotion(IndexPath.arbitrary)))
            XCTAssertTrue(commands.isEmpty)
        }
    }

    func testSetItemsPerSection() {
        do {
            var model = Model()
            let commands = try! Module.update(for: .setItemsPerSection([1, 2]), model: &model)
            XCTAssertEqual(model, Model(itemsPerSection: [1, 2]))
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setItemsPerSection([3, 4]), model: &model)
            XCTAssertEqual(model, Model(itemsPerSection: [3, 4]))
            XCTAssertTrue(commands.isEmpty)
        }
    }

    func testSetViewSize() {
        do {
            var model = Model()
            let commands = try! Module.update(for: .setViewSize(Size(width: 1, height: 2)), model: &model)
            XCTAssertEqual(model, Model(viewSize: Size(width: 1, height: 2)))
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setViewSize(Size(width: 3, height: 4)), model: &model)
            XCTAssertEqual(model, Model(viewSize: Size(width: 3, height: 4)))
            XCTAssertTrue(commands.isEmpty)
        }
    }

}
