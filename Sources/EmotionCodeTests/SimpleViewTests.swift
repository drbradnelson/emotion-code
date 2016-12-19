import XCTest
@testable import EmotionCode

final class SimpleViewTests: XCTestCase {
        
    func testItemFramesCount() {
        var model = Model()
        let itemsPerSection = [0, 1, 2, 3 ,4]
        model.itemsPerSection = itemsPerSection
        
        let view = Module.view(for: model)

        XCTAssertEqual(view.itemFrames.count, itemsPerSection.count)
    }

    func testItemFramesPerSectionCount() {
        var model = Model()
        let itemsPerSection = [0, 1, 2, 3, 4]
        model.itemsPerSection = itemsPerSection

        let view = Module.view(for: model)

        XCTAssertEqual(view.itemFrames[0].count, itemsPerSection[0])
        XCTAssertEqual(view.itemFrames[1].count, itemsPerSection[1])
        XCTAssertEqual(view.itemFrames[2].count, itemsPerSection[2])
        XCTAssertEqual(view.itemFrames[3].count, itemsPerSection[3])
        XCTAssertEqual(view.itemFrames[4].count, itemsPerSection[4])
    }

    func testColumnHeaderFramesCount() {
        var model = Model()
        model.itemsPerSection = [
            0, 1,
            2, 3,
            4
        ]

        let view = Module.view(for: model)

        XCTAssertEqual(view.columnHeaderFrames.count, View.numberOfColumns)
    }

    func testRowHeaderFramesCount() {
        var model = Model()

        model.itemsPerSection = [
            0, 1,
            2, 3,
            4
        ]

        let view = Module.view(for: model)

        XCTAssertEqual(view.rowHeaderFrames.count, 3)
    }
    
}
