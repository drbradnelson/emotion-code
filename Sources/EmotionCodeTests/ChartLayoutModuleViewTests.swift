import XCTest
import Elm

@testable import EmotionCode

// swiftlint:disable type_body_length

final class ChartLayoutModuleViewTests: XCTestCase, ViewTests {

    var fixture = ViewFixture<ChartLayoutModule>()
    let failureReporter = XCTFail

    func testChartWidthForAllMode() {
        model = .init(
            flags: .init(mode: .all),
            viewSize: Size(width: 1)
        )
        expect(view.chartSize.width, 1)
    }

    func testChartHeightForAllModeWhenNotCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            itemHeight: 5,
            minViewHeightForCompactLayout: 11,
            viewSize: Size(height: 10)
        )
        expect(view.chartSize.height, 2 + 3 + 4 + 5 + 2)
    }

    func testChartHeightForAllModeWhenCompact() {
        model = .init(
            flags: .init(mode: .all),
            minViewHeightForCompactLayout: 1,
            viewSize: Size(height: 1 + 1)
        )
        expect(view.chartSize.height, 1 + 1)
    }

    func testChartWidthForSectionMode() {
        model = .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(width: 3),
            viewSize: Size(width: 10)
        )
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2
        expect(view.chartSize.width, expected)
    }

    func testChartHeightForSectionMode() {
        model = .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            viewSize: Size(height: 10)
        )
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2
        expect(view.chartSize.height, expected)
    }

    func testContentOffsetForAllMode() {
        model = .init(flags: .init(mode: .all))
        expect(view.proposedVerticalContentOffset, nil)
    }

    func testContentOffsetForSectionMode0() {
        model = .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1,
                topContentInset: 4
            ),
            contentPadding: 2,
            headerSize: Size(height: 3)
        )
        expect(view.proposedVerticalContentOffset, 2 + 3 - 4)
    }

    func testContentOffsetForSectionMode1() {
        model = .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 4
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            viewSize: Size(height: 10)
        )
        let expected = 2 + 3 + 2 + (10 - 2 - 2) - 4
        expect(view.proposedVerticalContentOffset, expected)
    }

    func testContentOffsetForEmotionMode() {
        model = .init(
            flags: .init(
                mode: .emotion(IndexPath(item: 1, section: 1)),
                itemsPerSection: [1, 2],
                numberOfColumns: 1,
                topContentInset: 4
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            viewSize: Size(height: 10)
        )
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2) - 4
        expect(view.proposedVerticalContentOffset, expected)
    }

    func testColumnHeaderFrameCount() {
        model = .init(
            flags: .init(
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            )
        )
        expect(view.columnHeaderFrames.count, 2)
    }

    func testColumnHeaderWidthForAllMode() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 100)
        )
        let expected = (100 - (2 + 2 + 4 + 3)) / 1
        expect(view.columnHeaderFrames[safe: 0]?.size.width, expected)
    }

    func testColumnHeaderHeight() {
        model = .init(
            flags: .init(
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            headerSize: Size(height: 2)
        )
        expect(view.columnHeaderFrames[safe: 0]?.size.height, 2)
    }

    func testColumnHeaderXForAllModeWhenNotCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
        )
        expect(view.columnHeaderFrames[safe: 0]?.origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenNotCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            minViewHeightForCompactLayout: 21,
            viewSize: Size(width: 20, height: 20)
        )
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        expect(view.columnHeaderFrames[safe: 1]?.origin.x, expected)
    }

    func testColumnHeaderXForAllModeWhenCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
        )
        expect(view.columnHeaderFrames[safe: 0]?.origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(width: 20, height: 20)
        )
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        expect(view.columnHeaderFrames[safe: 1]?.origin.x, expected)
    }

    func testColumnHeaderY() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 19)
        )
        expect(view.columnHeaderFrames[safe: 0]?.origin.y, 3)
        expect(view.columnHeaderFrames[safe: 1]?.origin.y, 3)
    }

    func testRowHeaderFrameCount() {
        model = .init(
            flags: .init(
                itemsPerSection: [1, 1],
                numberOfColumns: 1
            )
        )
        expect(view.rowHeaderFrames.count, 2)
    }

    func testRowHeaderWidth() {
        model = .init(
            flags: .init(
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            headerSize: Size(width: 2)
        )
        expect(view.rowHeaderFrames[safe: 0]?.size.width, 2)
    }

    func testRowHeaderHeightForAllModeWhenNotCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            itemHeight: 2,
            minViewHeightForCompactLayout: 101,
            viewSize: Size(height: 100)
        )
        expect(view.rowHeaderFrames[safe: 0]?.size.height, 2)
    }

    func testSecondRowHeaderHeightForAllModeWhenNotCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 1
            ),
            itemHeight: 2,
            minViewHeightForCompactLayout: 101,
            viewSize: Size(height: 100)
        )
        expect(view.rowHeaderFrames[safe: 1]?.size.height, 2)
    }

    func testRowHeaderHeightForAllModeWhenCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 10,
            viewSize: Size(height: 10)
        )
        let expected = (10 - (2 + 2 + 3 + 4)) / 1
        expect(view.rowHeaderFrames[safe: 0]?.size.height, expected)
    }

    func testSecondRowHeaderHeightForAllModeWhenCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 10,
            viewSize: Size(height: 10)
        )
        let expected = (10 - (2 + 2 + 3 + 4 + 4)) / 2
        expect(view.rowHeaderFrames[safe: 1]?.size.height, expected)
    }

    func testRowHeaderX() {
        model = .init(
            flags: .init(
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2
        )
        expect(view.rowHeaderFrames[safe: 0]?.origin.x, 2)
    }

    func testRowHeaderYForAllModeWhenNotCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4)
        )
        expect(view.rowHeaderFrames[safe: 0]?.origin.y, 2 + 3 + 4)
    }

    func testSecondRowHeaderYForAllModeWhenNotCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            itemHeight: 5,
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
        )
        let expected = 2 + 3 + 4 + 5 + 4
        expect(view.rowHeaderFrames[safe: 1]?.origin.y, expected)
    }

    func testRowHeaderYForAllModeWhenCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
        )
        let expected = 2 + 3 + 4
        expect(view.rowHeaderFrames[safe: 0]?.origin.y, expected)
    }

    func testSecondRowHeaderYForAllModeWhenCompact() {
        model = .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
        )
        let expectedRowHeight = (20 - (2 + 2 + 3 + 4 + 4)) / 2
        let expected = 2 + 3 + 4 + expectedRowHeight + 4
        expect(view.rowHeaderFrames[safe: 1]?.origin.y, expected)
    }

    func testItemHeightWhenNotCompact() {
        model = .init(
            flags: .init(
                //                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            itemHeight: 2,
            minViewHeightForCompactLayout: 11,
            viewSize: Size(height: 10)
        )
        expect(view.itemFrames[safe: 0]?[safe: 0]?.size.height, 2)
    }

    func testItemHeightWhenCompact1() {
        model = .init(
            flags: .init(
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 100,
            viewSize: Size(height: 100)
        )
        let expected = 100 - (2 + 2 + 3 + 4)
        expect(view.itemFrames[safe: 0]?[safe: 0]?.size.height, expected)
    }

    func testItemHeightWhenCompact2() {
        model = .init(
            flags: .init(
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            minViewHeightForCompactLayout: 100,
            viewSize: Size(height: 100)
        )
        let expected = Int(round(Double(100 - (3 + 3 + 4 + 5)) / Double(2)))
        expect(view.itemFrames[safe: 0]?[safe: 0]?.size.height, expected)
        expect(view.itemFrames[safe: 0]?[safe: 1]?.size.height, expected)
    }

    func testItemWidth() {
        model = .init(
            flags: .init(
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 20)
        )
        let expected = 20 - (2 + 2 + 3 + 4)
        expect(view.itemFrames[safe: 0]?[safe: 0]?.size.width, expected)
    }

    func testItemX() {
        model = .init(
            flags: .init(
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4)
        )
        expect(view.itemFrames[safe: 0]?[safe: 0]?.origin.x, 2 + 3 + 4)
    }

    func testSecondItemX() {
        model = .init(
            flags: .init(
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            viewSize: Size(width: 20)
        )
        let expectedItemWidth = (20 - (3 + 3 + 5 + 5 + 4)) / 2
        let expected = 3 + 4 + 5 + expectedItemWidth + 5
        expect(view.itemFrames[safe: 1]?[safe: 0]?.origin.x, expected)
    }

    func testItemY() {
        model = .init(
            flags: .init(
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4)
        )
        expect(view.itemFrames[safe: 0]?[safe: 0]?.origin.y, 2 + 3 + 4)
    }

    func testSecondItemYWhenNotCompact() {
        model = .init(
            flags: .init(
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            itemHeight: 6,
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
        )
        expect(view.itemFrames[safe: 0]?[safe: 1]?.origin.y, 3 + 4 + 5 + 6)
    }

    func testSecondItemYWhenCompact() {
        model = .init(
            flags: .init(
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            itemHeight: 6,
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
        )
        let expectedItemHeight = Int(round(Double(20 - (3 + 3 + 4 + 5)) / Double(2)))
        let expected = 3 + 4 + 5 + expectedItemHeight
        expect(view.itemFrames[safe: 0]?[safe: 1]?.origin.y, expected)
    }

}
