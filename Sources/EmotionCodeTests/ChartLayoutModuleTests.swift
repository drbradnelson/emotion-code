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
            XCTAssertEqual(model.mode!, .section(0))
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setMode(.emotion(IndexPath.arbitrary)), model: &model)
            XCTAssertEqual(model.mode!, .emotion(IndexPath.arbitrary))
            XCTAssertTrue(commands.isEmpty)
        }
    }

    func testSetItemsPerSection() {
        do {
            var model = Model()
            let commands = try! Module.update(for: .setItemsPerSection([1, 2]), model: &model)
            XCTAssertEqual(model.itemsPerSection!, [1, 2])
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setItemsPerSection([3, 4]), model: &model)
            XCTAssertEqual(model.itemsPerSection!, [3, 4])
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
            XCTAssertEqual(model.viewSize!, Size(width: 1, height: 2))
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setViewSize(Size(width: 3, height: 4)), model: &model)
            XCTAssertEqual(model.viewSize!, Size(width: 3, height: 4))
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

    func testSetTopContentInset() {
        do {
            var model = Model()
            let commands = try! Module.update(for: .setTopContentInset(-1), model: &model)
            XCTAssertEqual(model.topContentInset, -1)
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setTopContentInset(0), model: &model)
            XCTAssertEqual(model.topContentInset, 0)
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model()
            let commands = try! Module.update(for: .setTopContentInset(1), model: &model)
            XCTAssertEqual(model.topContentInset, 1)
            XCTAssertTrue(commands.isEmpty)
        }
    }

    func testChartWidthForAllMode() {
        let model = Model(
            mode: .all,
            viewSize: Size(width: 1)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.chartSize.width, 1)
    }

    func testChartHeightForAllModeWhenNotCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            itemHeight: 5,
            minViewHeightForCompactLayout: 11,
            viewSize: Size(height: 10)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.chartSize.height, 2 + 3 + 4 + 5 + 2)
    }

    func testChartHeightForAllModeWhenCompact() {
        let model = Model(
            mode: .all,
            minViewHeightForCompactLayout: 1,
            viewSize: Size(height: 1 + 1)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.chartSize.height, 1 + 1)
    }

    func testChartWidthForSectionMode() {
        let model = Model(
            mode: .section(0),
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(width: 3),
            viewSize: Size(width: 10)
        )
        let view = try! Module.view(for: model)
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2
        XCTAssertEqual(view.chartSize.width, expected)
    }

    func testChartHeightForSectionMode() {
        let model = Model(
            mode: .section(0),
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            viewSize: Size(height: 10)
        )
        let view = try! Module.view(for: model)
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2
        XCTAssertEqual(view.chartSize.height, expected)
    }

    func testContentOffsetForAllMode() {
        let model = Model(mode: .all)
        let view = try! Module.view(for: model)
        XCTAssertNil(view.proposedVerticalContentOffset)
    }

    func testContentOffsetForSectionMode0() {
        let model = Model(
            mode: .section(0),
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            topContentInset: 4
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.proposedVerticalContentOffset, 2 + 3 - 4)
    }

    func testContentOffsetForSectionMode1() {
        let model = Model(
            mode: .section(1),
            numberOfColumns: 1,
            itemsPerSection: [1, 1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            topContentInset: 4,
            viewSize: Size(height: 10)
        )
        let view = try! Module.view(for: model)
        let expected = 2 + 3 + 2 + (10 - 2 - 2) - 4
        XCTAssertEqual(view.proposedVerticalContentOffset, expected)
    }

    func testContentOffsetForEmotionMode() {
        let model = Model(
            mode: .emotion(IndexPath(item: 1, section: 1)),
            numberOfColumns: 1,
            itemsPerSection: [1, 2],
            contentPadding: 2,
            headerSize: Size(height: 3),
            topContentInset: 4,
            viewSize: Size(height: 10)
        )
        let view = try! Module.view(for: model)
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2) - 4
        XCTAssertEqual(view.proposedVerticalContentOffset, expected)
    }

    func testColumnHeaderFrameCount() {
        let model = Model(
            numberOfColumns: 2,
            itemsPerSection: [1, 1]
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames.count, 2)
    }

    func testColumnHeaderWidthForAllMode() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 100)
        )
        let view = try! Module.view(for: model)
        let expected = (100 - (2 + 2 + 4 + 3)) / 1
        XCTAssertEqual(view.columnHeaderFrames[0].size.width, expected)
    }

    func testColumnHeaderHeight() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [1],
            headerSize: Size(height: 2)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].size.height, 2)
    }

    func testColumnHeaderXForAllModeWhenNotCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenNotCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 2,
            itemsPerSection: [1, 1],
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            minViewHeightForCompactLayout: 21,
            viewSize: Size(width: 20, height: 20)
        )
        let view = try! Module.view(for: model)
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        XCTAssertEqual(view.columnHeaderFrames[1].origin.x, expected)
    }

    func testColumnHeaderXForAllModeWhenCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 2,
            itemsPerSection: [1, 1],
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(width: 20, height: 20)
        )
        let view = try! Module.view(for: model)
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        XCTAssertEqual(view.columnHeaderFrames[1].origin.x, expected)
    }

    func testColumnHeaderY() {
        let model = Model(
            mode: .all,
            numberOfColumns: 2,
            itemsPerSection: [1, 1],
            contentPadding: 3,
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 19)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.columnHeaderFrames[0].origin.y, 3)
        XCTAssertEqual(view.columnHeaderFrames[1].origin.y, 3)
    }

    func testRowHeaderFrameCount() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [1, 1]
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames.count, 2)
    }

    func testRowHeaderWidth() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [1],
            headerSize: Size(width: 2)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].size.width, 2)
    }

    func testRowHeaderHeightForAllModeWhenNotCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1],
            itemHeight: 2,
            minViewHeightForCompactLayout: 101,
            viewSize: Size(height: 100)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].size.height, 2)
    }

    func testSecondRowHeaderHeightForAllModeWhenNotCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1, 1],
            itemHeight: 2,
            minViewHeightForCompactLayout: 101,
            viewSize: Size(height: 100)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[1].size.height, 2)
    }

    func testRowHeaderHeightForAllModeWhenCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 10,
            viewSize: Size(height: 10)
        )
        let view = try! Module.view(for: model)
        let expected = (10 - (2 + 2 + 3 + 4)) / 1
        XCTAssertEqual(view.rowHeaderFrames[0].size.height, expected)
    }

    func testSecondRowHeaderHeightForAllModeWhenCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1, 1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 10,
            viewSize: Size(height: 10)
        )
        let view = try! Module.view(for: model)
        let expected = (10 - (2 + 2 + 3 + 4 + 4)) / 2
        XCTAssertEqual(view.rowHeaderFrames[1].size.height, expected)
    }

    func testRowHeaderX() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].origin.x, 2)
    }

    func testRowHeaderYForAllModeWhenNotCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.rowHeaderFrames[0].origin.y, 2 + 3 + 4)
    }

    func testSecondRowHeaderYForAllModeWhenNotCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1, 1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            itemHeight: 5,
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
        )
        let view = try! Module.view(for: model)
        let expected = 2 + 3 + 4 + 5 + 4
        XCTAssertEqual(view.rowHeaderFrames[1].origin.y, expected)
    }

    func testRowHeaderYForAllModeWhenCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
        )
        let view = try! Module.view(for: model)
        let expected = 2 + 3 + 4
        XCTAssertEqual(view.rowHeaderFrames[0].origin.y, expected)
    }

    func testSecondRowHeaderYForAllModeWhenCompact() {
        let model = Model(
            mode: .all,
            numberOfColumns: 1,
            itemsPerSection: [1, 1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
        )
        let view = try! Module.view(for: model)
        let expectedRowHeight = (20 - (2 + 2 + 3 + 4 + 4)) / 2
        let expected = 2 + 3 + 4 + expectedRowHeight + 4
        XCTAssertEqual(view.rowHeaderFrames[1].origin.y, expected)
    }

    func testItemHeightWhenNotCompact() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [1],
            itemHeight: 2,
            minViewHeightForCompactLayout: 11,
            viewSize: Size(height: 10)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.itemFrames[0][0].size.height, 2)
    }

    func testItemHeightWhenCompact1() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 100,
            viewSize: Size(height: 100)
        )
        let view = try! Module.view(for: model)
        let expected = 100 - (2 + 2 + 3 + 4)
        XCTAssertEqual(view.itemFrames[0][0].size.height, expected)
    }

    func testItemHeightWhenCompact2() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [2],
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            minViewHeightForCompactLayout: 100,
            viewSize: Size(height: 100)
        )
        let view = try! Module.view(for: model)
        let expected = Int(round(Double(100 - (3 + 3 + 4 + 5)) / Double(2)))
        XCTAssertEqual(view.itemFrames[0][0].size.height, expected)
        XCTAssertEqual(view.itemFrames[0][1].size.height, expected)
    }

    func testItemWidth() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 20)
        )
        let view = try! Module.view(for: model)
        let expected = 20 - (2 + 2 + 3 + 4)
        XCTAssertEqual(view.itemFrames[0][0].size.width, expected)
    }

    func testItemX() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.itemFrames[0][0].origin.x, 2 + 3 + 4)
    }

    func testSecondItemX() {
        let model = Model(
            numberOfColumns: 2,
            itemsPerSection: [1, 1],
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            viewSize: Size(width: 20)
        )
        let view = try! Module.view(for: model)
        let expectedItemWidth = (20 - (3 + 3 + 5 + 5 + 4)) / 2
        let expected = 3 + 4 + 5 + expectedItemWidth + 5
        XCTAssertEqual(view.itemFrames[1][0].origin.x, expected)
    }

    func testItemY() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [1],
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.itemFrames[0][0].origin.y, 2 + 3 + 4)
    }

    func testSecondItemYWhenNotCompact() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [2],
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            itemHeight: 6,
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
        )
        let view = try! Module.view(for: model)
        XCTAssertEqual(view.itemFrames[0][1].origin.y, 3 + 4 + 5 + 6)
    }

    func testSecondItemYWhenCompact() {
        let model = Model(
            numberOfColumns: 1,
            itemsPerSection: [2],
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            itemHeight: 6,
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
        )
        let view = try! Module.view(for: model)
        let expectedItemHeight = Int(round(Double(20 - (3 + 3 + 4 + 5)) / Double(2)))
        let expected = 3 + 4 + 5 + expectedItemHeight
        XCTAssertEqual(view.itemFrames[0][1].origin.y, expected)
    }

}

// MARK: ...

private extension Model {
    init(
        mode: Mode = .all,
        numberOfColumns: Int = 2,
        itemsPerSection: [Int] = [],

        contentPadding: Int = Model().contentPadding,
        headerSize: Size = Model().headerSize,
        sectionSpacing: Size = Model().sectionSpacing,
        itemHeight: Int = Model().itemHeight,
        itemSpacing: Int = Model().itemSpacing,

        topContentInset: Int = 0,
        minViewHeightForCompactLayout: Int = Model().minViewHeightForCompactLayout,
        viewSize: Size = .zero
    ) {
        self.mode = mode
        self.numberOfColumns = numberOfColumns
        self.itemsPerSection = itemsPerSection

        self.contentPadding = contentPadding
        self.headerSize = headerSize
        self.sectionSpacing = sectionSpacing
        self.itemHeight = itemHeight
        self.itemSpacing = itemSpacing

        self.topContentInset = topContentInset
        self.minViewHeightForCompactLayout = minViewHeightForCompactLayout
        self.viewSize = viewSize
    }
}

private extension Size {
    init(width: Int = 0, height: Int = 0) {
        self.width = width
        self.height = height
    }
}

private extension IndexPath {
    static let arbitrary = IndexPath(item: 10, section: 20)
}

extension Mode: StringEquatable {}
extension Model: StringEquatable {}
extension View: StringEquatable {}

extension Size: StringEquatable {}
extension Point: StringEquatable {}
extension Rect: StringEquatable {}
