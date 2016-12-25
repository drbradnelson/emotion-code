import XCTest
@testable import EmotionCode

// swiftlint:disable type_body_length

typealias Module = ChartLayoutModule
typealias Message = Module.Message
typealias Mode = Module.Mode
typealias Model = Module.Model
typealias View = Module.View

final class ChartLayoutModuleTests: XCTestCase {

    func testSetMode() {
        do {
            var model = Model()
            let commands = try! Module.update(for: .setMode(.section(0)), model: &model)
            XCTAssertEqual(model.mode, .section(0))
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setMode(.emotion(IndexPath.arbitrary)), model: &model)
            XCTAssertEqual(model.mode, .emotion(IndexPath.arbitrary))
            XCTAssertTrue(commands.isEmpty)
        }
    }

    func testSetItemsPerSection() {
        do {
            var model = Model()
            let commands = try! Module.update(for: .setItemsPerSection([1, 2]), model: &model)
            XCTAssertEqual(model.itemsPerSection, [1, 2])
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setItemsPerSection([3, 4]), model: &model)
            XCTAssertEqual(model.itemsPerSection, [3, 4])
            XCTAssertTrue(commands.isEmpty)
        }
    }

    func testSetViewSize() {
        do {
            var model = Model()
            let commands = try! Module.update(for: .setViewSize(Size(width: 1, height: 2)), model: &model)
            XCTAssertEqual(model.viewSize, Size(width: 1, height: 2))
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setViewSize(Size(width: 3, height: 4)), model: &model)
            XCTAssertEqual(model.viewSize, Size(width: 3, height: 4))
            XCTAssertTrue(commands.isEmpty)
        }
    }

    func testSetNumberOfColumns() {
        var model = Model()
        let commands = try! Module.update(for: .setNumberOfColumns(1), model: &model)
        XCTAssertEqual(model.numberOfColumns, 1)
        XCTAssertTrue(commands.isEmpty)
    }

    func testChartWidthForAllMode() {
        var model = Model()
        model.mode = .all
        model.viewSize.width = 1
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.chartSize.width, 1)
    }

    func testChartHeightForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4
        model.itemHeight = 5
        model.minViewHeightForCompactLayout = 11
        model.viewSize.height = 10
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.chartSize.height, 2 + 3 + 4 + 5 + 2)
    }

    func testChartHeightForAllModeWhenCompact() {
        var model = Model()
        model.mode = .all
        model.minViewHeightForCompactLayout = 1
        model.viewSize.height = 1 + 1
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.chartSize.height, 1 + 1)
    }

    func testChartWidthForSectionMode() {
        var model = Model()
        model.mode = .section(0)
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.width = 3
        model.viewSize.width = 10
        let view = try! Module.view(for: model)
        let expected = Int(2 + 3 + 2 + (10 - 2 - 2) + 2)
        XCTAssertEqual(view.chartSize.width, expected)
    }

    func testChartHeightForSectionMode() {
        var model = Model()
        model.mode = .section(0)
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.viewSize.height = 10
        let view = try! Module.view(for: model)
        let expected = Int(2 + 3 + 2 + (10 - 2 - 2) + 2)
        XCTAssertEqual(view.chartSize.height, expected)
    }

    func testContentOffsetForSectionMode0() {
        var model = Model()
        model.mode = .section(0)
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 1
        model.headerSize.height = 2
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.proposedVerticalContentOffset, 1 + 2)
    }

    func testContentOffsetForSectionMode1() {
        var model = Model()
        model.mode = .section(1)
        model.numberOfColumns = 1
        model.itemsPerSection = [1, 1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.viewSize.height = 10
        let view = try! Module.view(for: model)
        let expected = Int(2 + 3 + 2 + (10 - 2 - 2))
        XCTAssertEqual(view.proposedVerticalContentOffset, expected)
    }

    func testContentOffsetForEmotionMode() {
        var model = Model()
        model.mode = .emotion(IndexPath(item: 1, section: 1))
        model.viewSize = Size(width: 200, height: 300)
        model.numberOfColumns = 1
        model.itemsPerSection = [1, 2]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.viewSize.height = 10
        let view = try! Module.view(for: model)
        let expected = Int(2 + 3 + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2))
        XCTAssertEqual(view.proposedVerticalContentOffset, expected)
    }

    func testColumnHeaderFrameCount() {
        var model = Model()
        model.numberOfColumns = 2
        model.itemsPerSection = [1, 1]
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames.count, 2)
    }

    func testColumnHeaderWidthForAllMode() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.width = 3
        model.sectionSpacing.width = 4
        model.viewSize.width = 100
        let view = try! Module.view(for: model)
        let expected = Int((100 - (2 + 2 + 4 + 3)) / 1)
        XCTAssertEqual(view.columnHeaderFrames[0].size.width, expected)
    }

    func testColumnHeaderHeight() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.headerSize.height = 2
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].size.height, 2)
    }

    func testColumnHeaderOriginXForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.width = 3
        model.sectionSpacing.width = 4
        model.minViewHeightForCompactLayout = 20
        model.viewSize.height = 19
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].origin.x, 2 + 3 + 4)
    }

    func testColumnHeaderOriginXForAllModeWhenCompact() {
        // ...
    }

    func testColumnHeaderOriginYForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.minViewHeightForCompactLayout = 20
        model.viewSize.height = 19
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].origin.y, 2)
    }

    func testColumnHeaderOriginYForAllModeWhenCompact() {
        // ...
    }

    func testRowHeaderFrameCount() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1, 1]
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames.count, 2)
    }

    func testRowHeaderWidth() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.headerSize.width = 2
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].size.width, 2)
    }

    func testRowHeaderHeightForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.itemHeight = 5
        model.minViewHeightForCompactLayout = 101
        model.viewSize.height = 100
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].size.height, 5)
    }

    func testRowHeaderHeightForAllModeWhenCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4
        model.minViewHeightForCompactLayout = 10
        model.viewSize.height = 10
        let view = try! Module.view(for: model)
        let expected = Int((10 - (2 + 2 + 3 + 4)) / 1)
        XCTAssertEqual(view.rowHeaderFrames[0].size.height, expected)
    }

    func testRowHeaderX() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].origin.x, 2)
    }

    func testRowHeaderYForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4

        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].origin.y, 2 + 3 + 4)
    }

    func testSecondRowHeaderYForAllModeWhenCompact() {
        // ...
    }

    func testSecondRowHeaderYForAllModeWhenNotCompact() {
        // ...
    }

    func testItemHeightWhenNotCompact() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.itemHeight = 2
        model.minViewHeightForCompactLayout = 101
        model.viewSize.height = 100
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.itemFrames[0][0].size.height, 2)
    }

    func testItemHeightWhenCompact() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4
        model.minViewHeightForCompactLayout = 100
        model.viewSize.height = 100
        let view = try! Module.view(for: model)
        let expected = Int(100 - 2 - 2 - 3 - 4)
        XCTAssertEqual(view.itemFrames[0][0].size.height, expected)
    }

}

// MARK: ...

extension IndexPath {
    static let arbitrary = IndexPath(item: 10, section: 20)
}

extension Mode: StringEquatable {}
extension Model: StringEquatable {}
extension View: StringEquatable {}

extension Size: StringEquatable {}
extension Point: StringEquatable {}
extension Rect: StringEquatable {}
