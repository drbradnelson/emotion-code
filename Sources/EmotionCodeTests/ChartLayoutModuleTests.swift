import XCTest
@testable import EmotionCode

// swiftlint:disable type_body_length

typealias Module = ChartLayoutModule
typealias Message = Module.Message
typealias Mode = Module.Mode
typealias Model = Module.Model
typealias View = Module.View
typealias Failure = Module.Failure

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
        do {
            var model = Model()
            XCTAssertThrowsError(try Module.update(for: .setItemsPerSection([]), model: &model), "") { error in
                XCTAssertEqual(error.localizedDescription, Failure.missingItems.localizedDescription)
            }
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
        do {
            var model = Model()
            XCTAssertThrowsError(try Module.update(for: .setViewSize(Size(width: 0, height: 1)), model: &model), "") { error in
                XCTAssertEqual(error.localizedDescription, Failure.zeroViewSize.localizedDescription)
            }
        }
        do {
            var model = Model()
            XCTAssertThrowsError(try Module.update(for: .setViewSize(Size(width: 1, height: -1)), model: &model), "") { error in
                XCTAssertEqual(error.localizedDescription, Failure.negativeViewSize.localizedDescription)
            }
        }
    }

    func testSetNumberOfColumns() {
        do {
            var model = Model()
            let commands = try! Module.update(for: .setNumberOfColumns(1), model: &model)
            XCTAssertEqual(model.numberOfColumns, 1)
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            XCTAssertThrowsError(try Module.update(for: .setNumberOfColumns(0), model: &model), "") { error in
                XCTAssertEqual(error.localizedDescription, Failure.zeroNumberOfColumns.localizedDescription)
            }
        }
        do {
            var model = Model()
            XCTAssertThrowsError(try Module.update(for: .setNumberOfColumns(-1), model: &model), "") { error in
                XCTAssertEqual(error.localizedDescription, Failure.negativeNumberOfColumns.localizedDescription)
            }
        }
    }

    func testChartWidthForAllMode() {
        var model = Model()
        model.mode = .all
        model.viewSize.width = 1
        let view = Module.view(for: model)
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
        let view = Module.view(for: model)
        XCTAssertEqual(view.chartSize.height, 2 + 3 + 4 + 5 + 2)
    }

    func testChartHeightForAllModeWhenCompact() {
        var model = Model()
        model.mode = .all
        model.minViewHeightForCompactLayout = 1
        model.viewSize.height = 1 + 1
        let view = Module.view(for: model)
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
        let view = Module.view(for: model)
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2
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
        let view = Module.view(for: model)
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2
        XCTAssertEqual(view.chartSize.height, expected)
    }

    func testContentOffsetForSectionMode0() {
        var model = Model()
        model.mode = .section(0)
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.height = 3
        let view = Module.view(for: model)
        XCTAssertEqual(view.proposedVerticalContentOffset, 2 + 3)
    }

    func testContentOffsetForSectionMode1() {
        var model = Model()
        model.mode = .section(1)
        model.numberOfColumns = 1
        model.itemsPerSection = [1, 1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.viewSize.height = 10
        let view = Module.view(for: model)
        let expected = 2 + 3 + 2 + (10 - 2 - 2)
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
        let view = Module.view(for: model)
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2)
        XCTAssertEqual(view.proposedVerticalContentOffset, expected)
    }

    func testColumnHeaderFrameCount() {
        var model = Model()
        model.numberOfColumns = 2
        model.itemsPerSection = [1, 1]
        let view = Module.view(for: model)
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
        let view = Module.view(for: model)
        let expected = (100 - (2 + 2 + 4 + 3)) / 1
        XCTAssertEqual(view.columnHeaderFrames[0].size.width, expected)
    }

    func testColumnHeaderHeight() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.headerSize.height = 2
        let view = Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].size.height, 2)
    }

    func testColumnHeaderXForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.width = 3
        model.sectionSpacing.width = 4
        model.minViewHeightForCompactLayout = 21
        model.viewSize.height = 20
        let view = Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 2
        model.itemsPerSection = [1, 1]
        model.contentPadding = 3
        model.headerSize.width = 4
        model.sectionSpacing.width = 5
        model.minViewHeightForCompactLayout = 21
        model.viewSize.height = 20
        model.viewSize.width = 20
        let view = Module.view(for: model)
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        XCTAssertEqual(view.columnHeaderFrames[1].origin.x, expected)
    }

    func testColumnHeaderXForAllModeWhenCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.width = 3
        model.sectionSpacing.width = 4
        model.minViewHeightForCompactLayout = 20
        model.viewSize.height = 20
        let view = Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 2
        model.itemsPerSection = [1, 1]
        model.contentPadding = 3
        model.headerSize.width = 4
        model.sectionSpacing.width = 5
        model.minViewHeightForCompactLayout = 20
        model.viewSize.height = 20
        model.viewSize.width = 20
        let view = Module.view(for: model)
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        XCTAssertEqual(view.columnHeaderFrames[1].origin.x, expected)
    }

    func testColumnHeaderY() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 2
        model.itemsPerSection = [1, 1]
        model.contentPadding = 3
        model.minViewHeightForCompactLayout = 20
        model.viewSize.height = 19
        let view = Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].origin.y, 3)
        XCTAssertEqual(view.columnHeaderFrames[1].origin.y, 3)
    }

    func testRowHeaderFrameCount() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1, 1]
        let view = Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames.count, 2)
    }

    func testRowHeaderWidth() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.headerSize.width = 2
        let view = Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].size.width, 2)
    }

    func testRowHeaderHeightForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.itemHeight = 2
        model.minViewHeightForCompactLayout = 101
        model.viewSize.height = 100
        let view = Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].size.height, 2)
    }

    func testSecondRowHeaderHeightForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1, 1]
        model.itemHeight = 2
        model.minViewHeightForCompactLayout = 101
        model.viewSize.height = 100
        let view = Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[1].size.height, 2)
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
        let view = Module.view(for: model)
        let expected = (10 - (2 + 2 + 3 + 4)) / 1
        XCTAssertEqual(view.rowHeaderFrames[0].size.height, expected)
    }

    func testSecondRowHeaderHeightForAllModeWhenCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1, 1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4
        model.minViewHeightForCompactLayout = 10
        model.viewSize.height = 10
        let view = Module.view(for: model)
        let expected = (10 - (2 + 2 + 3 + 4 + 4)) / 2
        XCTAssertEqual(view.rowHeaderFrames[1].size.height, expected)
    }

    func testRowHeaderX() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        let view = Module.view(for: model)
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
        let view = Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].origin.y, 2 + 3 + 4)
    }

    func testSecondRowHeaderYForAllModeWhenNotCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1, 1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4
        model.itemHeight = 5
        model.minViewHeightForCompactLayout = 21
        model.viewSize.height = 20
        let view = Module.view(for: model)
        let expected = 2 + 3 + 4 + 5 + 4
        XCTAssertEqual(view.rowHeaderFrames[1].origin.y, expected)
    }

    func testRowHeaderYForAllModeWhenCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4
        model.minViewHeightForCompactLayout = 20
        model.viewSize.height = 20
        let view = Module.view(for: model)
        let expected = 2 + 3 + 4
        XCTAssertEqual(view.rowHeaderFrames[0].origin.y, expected)
    }

    func testSecondRowHeaderYForAllModeWhenCompact() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = [1, 1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4
        model.minViewHeightForCompactLayout = 20
        model.viewSize.height = 20
        let view = Module.view(for: model)
        let expectedRowHeight = (20 - (2 + 2 + 3 + 4 + 4)) / 2
        let expected = 2 + 3 + 4 + expectedRowHeight + 4
        XCTAssertEqual(view.rowHeaderFrames[1].origin.y, expected)
    }

    func testItemHeightWhenNotCompact() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.itemHeight = 2
        model.minViewHeightForCompactLayout = 101
        model.viewSize.height = 100
        let view = Module.view(for: model)
        XCTAssertEqual(view.itemFrames[0][0].size.height, 2)
    }

    func testItemHeightWhenCompact1() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4
        model.minViewHeightForCompactLayout = 100
        model.viewSize.height = 100
        let view = Module.view(for: model)
        let expected = 100 - (2 + 2 + 3 + 4)
        XCTAssertEqual(view.itemFrames[0][0].size.height, expected)
    }

    func testItemHeightWhenCompact2() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [2]
        model.contentPadding = 3
        model.headerSize.height = 4
        model.sectionSpacing.height = 5
        model.minViewHeightForCompactLayout = 100
        model.viewSize.height = 100
        let view = Module.view(for: model)
        let expected = Int(round(Double(100 - (3 + 3 + 4 + 5)) / Double(2)))
        XCTAssertEqual(view.itemFrames[0][0].size.height, expected)
        XCTAssertEqual(view.itemFrames[0][1].size.height, expected)
    }

    func testItemWidth() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.width = 3
        model.sectionSpacing.width = 4
        model.viewSize.width = 20
        let view = Module.view(for: model)
        let expected = 20 - (2 + 2 + 3 + 4)
        XCTAssertEqual(view.itemFrames[0][0].size.width, expected)
    }

    func testItemX() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.width = 3
        model.sectionSpacing.width = 4
        let view = Module.view(for: model)
        XCTAssertEqual(view.itemFrames[0][0].origin.x, 2 + 3 + 4)
    }

    func testSecondItemX() {
        var model = Model()
        model.numberOfColumns = 2
        model.itemsPerSection = [1, 1]
        model.contentPadding = 3
        model.headerSize.width = 4
        model.sectionSpacing.width = 5
        model.viewSize.width = 20
        let view = Module.view(for: model)
        let expectedItemWidth = (20 - (3 + 3 + 5 + 5 + 4)) / 2
        let expected = 3 + 4 + 5 + expectedItemWidth + 5
        XCTAssertEqual(view.itemFrames[1][0].origin.x, expected)
    }

    func testItemY() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [1]
        model.contentPadding = 2
        model.headerSize.height = 3
        model.sectionSpacing.height = 4
        let view = Module.view(for: model)
        XCTAssertEqual(view.itemFrames[0][0].origin.y, 2 + 3 + 4)
    }

    func testSecondItemYWhenNotCompact() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [2]
        model.contentPadding = 3
        model.headerSize.height = 4
        model.sectionSpacing.height = 5
        model.itemHeight = 6
        model.minViewHeightForCompactLayout = 21
        model.viewSize.height = 20
        let view = Module.view(for: model)
        XCTAssertEqual(view.itemFrames[0][1].origin.y, 3 + 4 + 5 + 6)
    }

    func testSecondItemYWhenCompact() {
        var model = Model()
        model.numberOfColumns = 1
        model.itemsPerSection = [2]
        model.contentPadding = 3
        model.headerSize.height = 4
        model.sectionSpacing.height = 5
        model.itemHeight = 6
        model.minViewHeightForCompactLayout = 20
        model.viewSize.height = 20
        let view = Module.view(for: model)
        let expectedItemHeight = Int(round(Double(20 - (3 + 3 + 4 + 5)) / Double(2)))
        let expected = 3 + 4 + 5 + expectedItemHeight
        XCTAssertEqual(view.itemFrames[0][1].origin.y, expected)
    }

    func testPerformance() {
        var model = Model()
        model.mode = .all
        model.numberOfColumns = 1
        model.itemsPerSection = Array(repeating: 1000, count: 1000)
        model.viewSize = Size(width: 200, height: 554)

        measure {
            _ = Module.view(for: model)
        }
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
