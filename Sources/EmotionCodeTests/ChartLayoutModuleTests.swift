import XCTest
import Elm

@testable import EmotionCode

// swiftlint:disable type_body_length

final class ChartLayoutModuleStartTests: XCTestCase, Tests {

    typealias Module = ChartLayoutModule
    let failureReporter = XCTFail

    // MARK: Start

    func testLoadMode1() {
        let start = expectStart(with: .init(mode: .all))
        expect(start?.model.mode, .all)
    }

    func testLoadMode2() {
        let start = expectStart(with: .init(mode: .section(0)))
        expect(start?.model.mode, .section(0))
    }

    func testLoadItemsPerSection1() {
        let start = expectStart(with: .init(itemsPerSection: [1]))
        expect(start?.model.itemsPerSection, [1])
    }

    func testLoadItemsPerSection2() {
        let start = expectStart(with: .init(itemsPerSection: [1, 2]))
        expect(start?.model.itemsPerSection, [1, 2])
    }

    func testLoadItemsPerSectionInvalid() {
        let failure = expectFailure(with: .init(itemsPerSection: []))
        expect(failure, .missingItems)
    }

    func testLoadNumberOfColumns1() {
        let start = expectStart(with: .init(numberOfColumns: 1))
        expect(start?.model.numberOfColumns, 1)
    }

    func testLoadNumberOfColumns2() {
        let start = expectStart(with: .init(numberOfColumns: 2))
        expect(start?.model.numberOfColumns, 2)
    }

    func testLoadNumberOfColumnsInvalid1() {
        let failure = expectFailure(with: .init(numberOfColumns: 0))
        expect(failure, .invalidNumberOfColums)
    }

    func testLoadNumberOfColumnsInvalid2() {
        let failure = expectFailure(with: .init(numberOfColumns: -1))
        expect(failure, .invalidNumberOfColums)
    }

    func testLoadNumberOfColumnsInvalid3() {
        let failure = expectFailure(with: .init(numberOfColumns: -2))
        expect(failure, .invalidNumberOfColums)
    }

    func testLoadTopContentInset1() {
        let start = expectStart(with: .init(topContentInset: 1))
        expect(start?.model.topContentInset, 1)
    }

    func testLoadTopContentInset2() {
        let start = expectStart(with: .init(topContentInset: 2))
        expect(start?.model.topContentInset, 2)
    }

    // MARK: Update

    func testSetViewSize1() {
        let update = expectUpdate(for: .setViewSize(.init(width: 1, height: 2)), model: .init(viewSize: .zero))
        expect(update?.model.viewSize, Size(width: 1, height: 2))
    }

    func testSetViewSize2() {
        let update = expectUpdate(for: .setViewSize(.init(width: 3, height: 4)), model: .init(viewSize: .zero))
        expect(update?.model.viewSize, Size(width: 3, height: 4))
    }

    func testSetViewSizeInvalid1() {
        let failure = expectFailure(for: .setViewSize(.init(width: 0, height: 10)), model: .init())
        expect(failure, .invalidViewSize)
    }

    func testSetViewSizeInvalid2() {
        let failure = expectFailure(for: .setViewSize(.init(width: -1, height: 10)), model: .init())
        expect(failure, .invalidViewSize)
    }

    func testSetViewSizeInvalid3() {
        let failure = expectFailure(for: .setViewSize(.init(width: 10, height: 0)), model: .init())
        expect(failure, .invalidViewSize)
    }

    func testSetViewSizeInvalid4() {
        let failure = expectFailure(for: .setViewSize(.init(width: 10, height: -1)), model: .init())
        expect(failure, .invalidViewSize)
    }

    // MARK: View

    func testChartWidthForAllMode() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 20)
        ))
        let expected = 2 + 3 + 4 + (20 - 2 - 2 - 3 - 4) / 1 + 2
        expect(view?.chartSize.width, expected)
    }

    func testChartHeightForAllModeWhenNotCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            itemHeight: 5,
            minViewHeightForCompactLayout: 11,
            viewSize: Size(height: 10)
            ))
        expect(view?.chartSize.height, 2 + 3 + 4 + 5 + 2)
    }

    func testChartHeightForAllModeWhenCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            minViewHeightForCompactLayout: 1,
            viewSize: Size(height: 1 + 1)
        ))
        expect(view?.chartSize.height, 1 + 1)
    }

    func testChartWidthForSectionMode() {
        let view = expectView(for: .init(
            mode: .section(0),
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(width: 3),
            viewSize: Size(width: 10)
            ))
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2
        expect(view?.chartSize.width, expected)
    }

    func testChartHeightForSectionMode() {
        let view = expectView(for: .init(
            mode: .section(0),
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            viewSize: Size(height: 10)
            ))
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2
        expect(view?.chartSize.height, expected)
    }

    func testContentOffsetForAllMode() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1
            ))
        expect(view?.proposedVerticalContentOffset, nil)
    }

    func testContentOffsetForSectionMode0() {
        let view = expectView(for: .init(
            mode: .section(0),
            itemsPerSection: [1],
            numberOfColumns: 1,
            topContentInset: 4,
            contentPadding: 2,
            headerSize: Size(height: 3)
        ))
        expect(view?.proposedVerticalContentOffset, 2 + 3 - 4)
    }

    func testContentOffsetForSectionMode1() {
        let view = expectView(for: .init(
            mode: .section(1),
            itemsPerSection: [1, 1],
            numberOfColumns: 1,
            topContentInset: 4,
            contentPadding: 2,
            headerSize: Size(height: 3),
            viewSize: Size(height: 10)
            ))
        let expected = 2 + 3 + 2 + (10 - 2 - 2) - 4
        expect(view?.proposedVerticalContentOffset, expected)
    }

    func testContentOffsetForEmotionMode() {
        let view = expectView(for: .init(
            mode: .emotion(IndexPath(item: 1, section: 1)),
            itemsPerSection: [1, 2],
            numberOfColumns: 1,
            topContentInset: 4,
            contentPadding: 2,
            headerSize: Size(height: 3),
            viewSize: Size(height: 10)
            ))
        let expected = 2 + 3 + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2) + 2 + (10 - 2 - 2) - 4
        expect(view?.proposedVerticalContentOffset, expected)
    }

    func testColumnHeaderFrameCount() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 2
            ))
        expect(view?.columnHeaderFrames.count, 2)
    }

    func testColumnHeaderWidthForAllMode() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 100)
            ))
        let expected = (100 - (2 + 2 + 4 + 3)) / 1
        expect(view?.columnHeaderFrames[safe: 0]?.size.width, expected)
    }

    func testColumnHeaderHeight() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            headerSize: Size(height: 2)
            ))
        expect(view?.columnHeaderFrames[safe: 0]?.size.height, 2)
    }

    func testColumnHeaderXForAllModeWhenNotCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
            ))
        expect(view?.columnHeaderFrames[safe: 0]?.origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenNotCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 2,
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            minViewHeightForCompactLayout: 21,
            viewSize: Size(width: 20, height: 20)
            ))
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        expect(view?.columnHeaderFrames[safe: 1]?.origin.x, expected)
    }

    func testColumnHeaderXForAllModeWhenCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
            ))
        expect(view?.columnHeaderFrames[safe: 0]?.origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 2,
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(width: 20, height: 20)
            ))
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        expect(view?.columnHeaderFrames[safe: 1]?.origin.x, expected)
    }

    func testColumnHeaderY() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 2,
            contentPadding: 3,
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 19)
            ))
        expect(view?.columnHeaderFrames[safe: 0]?.origin.y, 3)
        expect(view?.columnHeaderFrames[safe: 1]?.origin.y, 3)
    }

    func testRowHeaderFrameCount() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 1
            ))
        expect(view?.rowHeaderFrames.count, 2)
    }

    func testRowHeaderWidth() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            headerSize: Size(width: 2)
            ))
        expect(view?.rowHeaderFrames[safe: 0]?.size.width, 2)
    }

    func testRowHeaderHeightForAllModeWhenNotCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            itemHeight: 2,
            minViewHeightForCompactLayout: 101,
            viewSize: Size(height: 100)
            ))
        expect(view?.rowHeaderFrames[safe: 0]?.size.height, 2)
    }

    func testSecondRowHeaderHeightForAllModeWhenNotCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 1,
            itemHeight: 2,
            minViewHeightForCompactLayout: 101,
            viewSize: Size(height: 100)
            ))
        expect(view?.rowHeaderFrames[safe: 1]?.size.height, 2)
    }

    func testRowHeaderHeightForAllModeWhenCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 10,
            viewSize: Size(height: 10)
            ))
        let expected = (10 - (2 + 2 + 3 + 4)) / 1
        expect(view?.rowHeaderFrames[safe: 0]?.size.height, expected)
    }

    func testSecondRowHeaderHeightForAllModeWhenCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 10,
            viewSize: Size(height: 10)
            ))
        let expected = (10 - (2 + 2 + 3 + 4 + 4)) / 2
        expect(view?.rowHeaderFrames[safe: 1]?.size.height, expected)
    }

    func testRowHeaderX() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2
            ))
        expect(view?.rowHeaderFrames[safe: 0]?.origin.x, 2)
    }

    func testRowHeaderYForAllModeWhenNotCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4)
            ))
        expect(view?.rowHeaderFrames[safe: 0]?.origin.y, 2 + 3 + 4)
    }

    func testSecondRowHeaderYForAllModeWhenNotCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            itemHeight: 5,
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
            ))
        let expected = 2 + 3 + 4 + 5 + 4
        expect(view?.rowHeaderFrames[safe: 1]?.origin.y, expected)
    }

    func testRowHeaderYForAllModeWhenCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
            ))
        let expected = 2 + 3 + 4
        expect(view?.rowHeaderFrames[safe: 0]?.origin.y, expected)
    }

    func testSecondRowHeaderYForAllModeWhenCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
            ))
        let expectedRowHeight = (20 - (2 + 2 + 3 + 4 + 4)) / 2
        let expected = 2 + 3 + 4 + expectedRowHeight + 4
        expect(view?.rowHeaderFrames[safe: 1]?.origin.y, expected)
    }

    func testItemHeightWhenNotCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            itemHeight: 2,
            minViewHeightForCompactLayout: 11,
            viewSize: Size(height: 10)
            ))
        expect(view?.itemFrames[safe: 0]?[safe: 0]?.size.height, 2)
    }

    func testItemHeightWhenCompact1() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 100,
            viewSize: Size(height: 100)
            ))
        let expected = 100 - (2 + 2 + 3 + 4)
        expect(view?.itemFrames[safe: 0]?[safe: 0]?.size.height, expected)
    }

    func testItemHeightWhenCompact2() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [2],
            numberOfColumns: 1,
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            minViewHeightForCompactLayout: 100,
            viewSize: Size(height: 100)
            ))
        let expected = Int(round(Double(100 - (3 + 3 + 4 + 5)) / Double(2)))
        expect(view?.itemFrames[safe: 0]?[safe: 0]?.size.height, expected)
        expect(view?.itemFrames[safe: 0]?[safe: 1]?.size.height, expected)
    }

    func testItemWidth() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 20)
            ))
        let expected = 20 - (2 + 2 + 3 + 4)
        expect(view?.itemFrames[safe: 0]?[safe: 0]?.size.width, expected)
    }

    func testItemX() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4)
            ))
        expect(view?.itemFrames[safe: 0]?[safe: 0]?.origin.x, 2 + 3 + 4)
    }

    func testSecondItemX() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1, 1],
            numberOfColumns: 2,
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            viewSize: Size(width: 20)
            ))
        let expectedItemWidth = (20 - (3 + 3 + 5 + 5 + 4)) / 2
        let expected = 3 + 4 + 5 + expectedItemWidth + 5
        expect(view?.itemFrames[safe: 1]?[safe: 0]?.origin.x, expected)
    }

    func testItemY() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [1],
            numberOfColumns: 1,
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4)
            ))
        expect(view?.itemFrames[safe: 0]?[safe: 0]?.origin.y, 2 + 3 + 4)
    }

    func testSecondItemYWhenNotCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [2],
            numberOfColumns: 1,
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            itemHeight: 6,
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
            ))
        expect(view?.itemFrames[safe: 0]?[safe: 1]?.origin.y, 3 + 4 + 5 + 6)
    }

    func testSecondItemYWhenCompact() {
        let view = expectView(for: .init(
            mode: .all,
            itemsPerSection: [2],
            numberOfColumns: 1,
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            itemHeight: 6,
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
            ))
        let expectedItemHeight = Int(round(Double(20 - (3 + 3 + 4 + 5)) / Double(2)))
        let expected = 3 + 4 + 5 + expectedItemHeight
        expect(view?.itemFrames[safe: 0]?[safe: 1]?.origin.y, expected)
    }

}

extension ChartLayoutModule.Flags {

    init(
        mode: ChartLayoutModule.Mode = .all,
        itemsPerSection: [Int] = [1],
        numberOfColumns: Int = 1,
        topContentInset: Int = 0
        ) {
        self.mode = mode
        self.itemsPerSection = itemsPerSection
        self.numberOfColumns = numberOfColumns
        self.topContentInset = topContentInset
    }

}

extension ChartLayoutModule.Model {
    init(
        mode: ChartLayoutModule.Mode = .all,
        itemsPerSection: [Int] = [0],
        numberOfColumns: Int = 1,
        topContentInset: Int = 2,
        contentPadding: Int = 10,
        headerSize: Size = Size(width: 30, height: 30),
        sectionSpacing: Size = Size(width: 5, height: 5),
        itemHeight: Int = 30,
        itemSpacing: Int = 10,
        minViewHeightForCompactLayout: Int = 554,
        viewSize: Size = .zero
        ) {
        self.mode = mode
        self.itemsPerSection = itemsPerSection
        self.numberOfColumns = numberOfColumns
        self.topContentInset = topContentInset
        self.contentPadding = contentPadding
        self.headerSize = headerSize
        self.sectionSpacing = sectionSpacing
        self.itemHeight = itemHeight
        self.itemSpacing = itemSpacing
        self.minViewHeightForCompactLayout = minViewHeightForCompactLayout
        self.viewSize = viewSize
    }
}

extension Size {
    init(width: Int = 0, height: Int = 0) {
        self.width = width
        self.height = height
    }
}

extension IndexPath {
    static let arbitrary = IndexPath(item: 10, section: 20)
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
