import XCTest
import Elm

@testable import EmotionCode

// swiftlint:disable type_body_length

final class ChartLayoutModuleStartTests: XCTestCase, Tests {

    typealias Module = ChartLayoutModule
    let failureReporter = XCTFail

    // MARK: Start

    func testLoadFlags1() {
        let flags: Module.Flags = .init(mode: .section(1), itemsPerSection: [2, 3], numberOfColumns: 4, topContentInset: 5)
        let model = expectModel(loading: flags)
        expect(model?.flags, flags)
    }

    func testLoadFlags2() {
        let flags: Module.Flags = .init(mode: .section(5), itemsPerSection: [4, 3], numberOfColumns: 2, topContentInset: 1)
        let model = expectModel(loading: flags)
        expect(model?.flags, flags)
    }

    func testLoadInvalidItemsPerSection() {
        let failure = expectFailure(loading: .init(itemsPerSection: []))
        expect(failure, .missingItems)
    }

    func testSetNumberOfColumnsInvalid1() {
        let failure = expectFailure(loading: .init(numberOfColumns: 0))
        expect(failure, .invalidNumberOfColums)
    }

    func testSetNumberOfColumnsInvalid2() {
        let failure = expectFailure(loading: .init(numberOfColumns: -1))
        expect(failure, .invalidNumberOfColums)
    }

    func testSetNumberOfColumnsInvalid3() {
        let failure = expectFailure(loading: .init(numberOfColumns: -2))
        expect(failure, .invalidNumberOfColums)
    }

    // MARK: Update

    func testSystemDidSetViewSize1() {
        let update = expectUpdate(for: .systemDidSetViewSize(.init(width: 1, height: 2)), model: .init(viewSize: .zero))
        expect(update?.model.viewSize, Size(width: 1, height: 2))
    }

    func testSystemDidSetViewSize2() {
        let update = expectUpdate(for: .systemDidSetViewSize(.init(width: 3, height: 4)), model: .init(viewSize: .zero))
        expect(update?.model.viewSize, Size(width: 3, height: 4))
    }

    func testSystemDidSetViewSizeInvalid1() {
        let failure = expectFailure(for: .systemDidSetViewSize(.init(height: 10)), model: .init())
        expect(failure, .invalidViewSize)
    }

    func testSystemDidSetViewSizeInvalid2() {
        let failure = expectFailure(for: .systemDidSetViewSize(.init(width: -1, height: 10)), model: .init())
        expect(failure, .invalidViewSize)
    }

    func testSystemDidSetViewSizeInvalid3() {
        let failure = expectFailure(for: .systemDidSetViewSize(.init(width: 10)), model: .init())
        expect(failure, .invalidViewSize)
    }

    func testSystemDidSetViewSizeInvalid4() {
        let failure = expectFailure(for: .systemDidSetViewSize(.init(width: 10, height: -1)), model: .init())
        expect(failure, .invalidViewSize)
    }

    func testSystemDidSetIsFocused1() {
        let update = expectUpdate(for: .systemDidSetIsFocused(true), model: .init(isFocused: true))
        expect(update?.model.isFocused, true)
    }

    func testSystemDidSetIsFocused2() {
        let update = expectUpdate(for: .systemDidSetIsFocused(true), model: .init(isFocused: false))
        expect(update?.model.isFocused, true)
    }

    func testSystemDidSetIsFocused3() {
        let update = expectUpdate(for: .systemDidSetIsFocused(false), model: .init(isFocused: false))
        expect(update?.model.isFocused, false)
    }

    func testSystemDidSetIsFocused4() {
        let update = expectUpdate(for: .systemDidSetIsFocused(false), model: .init(isFocused: true))
        expect(update?.model.isFocused, false)
    }

    // MARK: View

    func testChartWidthForAllMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 20)
        ))
        let expected = 2 + 3 + 4 + (20 - 2 - 2 - 3 - 4) / 1 + 2
        expect(view?.chartSize.width, expected)
    }

    func testChartHeightForAllModeWhenNotCompact() {
        let view = expectView(presenting: .init(
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
        ))
        expect(view?.chartSize.height, 2 + 3 + 4 + 5 + 2)
    }

    func testChartHeightForAllModeWhenCompact() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            minViewHeightForCompactLayout: 1,
            viewSize: Size(height: 1 + 1)
        ))
        expect(view?.chartSize.height, 1 + 1)
    }

    func testChartWidthForSectionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            viewSize: Size(width: 10)
        ))
        expect(view?.chartSize.width, 10)
    }

    func testChartHeightForSectionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            viewSize: Size(height: 10)
        ))
        expect(view?.chartSize.height, 10)
    }

    func testChartWidthForEmotionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            viewSize: Size(width: 10)
        ))
        expect(view?.chartSize.width, 10)
    }

    func testChartHeightForEmotionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            viewSize: Size(height: 10)
            ))
        expect(view?.chartSize.height, 10)
    }

    func testColumnHeaderFrameCount() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            )
        ))
        expect(view?.columnHeaders.count, 2)
    }

    func testColumnHeaderWidthForAllMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 100)
        ))
        let expected = (100 - (2 + 2 + 4 + 3)) / 1
        expect(view?.columnHeaders[safe: 0]?.frame.size.width, expected)
    }

    func testColumnHeaderWidthForSectionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            viewSize: Size(width: 100)
        ))
        let expected = 100 - (2 + 2)
        expect(view?.columnHeaders[safe: 0]?.frame.size.width, expected)
    }

    func testColumnHeaderWidthForEmotionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            viewSize: Size(width: 100)
        ))
        let expected = 100 - (2 + 2)
        expect(view?.columnHeaders[safe: 0]?.frame.size.width, expected)
    }

    func testColumnHeaderHeight() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            headerSize: Size(height: 2)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.size.height, 2)
    }

    func testColumnHeaderXForAllModeWhenNotCompact() {
        let view = expectView(presenting: .init(
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
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenNotCompact() {
        let view = expectView(presenting: .init(
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
        ))
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        expect(view?.columnHeaders[safe: 1]?.frame.origin.x, expected)
    }

    func testColumnHeaderXForAllModeWhenCompact() {
        let view = expectView(presenting: .init(
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
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.x, 2 + 3 + 4)
    }

    func testSecondColumnHeaderXForAllModeWhenCompact() {
        let view = expectView(presenting: .init(
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
        ))
        let expectedColumnWidth = (20 - (3 + 3 + 4 + 5 + 5)) / 2
        let expected = 3 + 4 + 5 + expectedColumnWidth + 5
        expect(view?.columnHeaders[safe: 1]?.frame.origin.x, expected)
    }

    func testColumnHeaderXForSectionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            viewSize: Size(width: 10)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.x, 3)
        expect(view?.columnHeaders[safe: 1]?.frame.origin.x, 10 + 3)
    }

    func testColumnHeaderXForSectionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            viewSize: Size(width: 10)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.x, 3 - 10)
        expect(view?.columnHeaders[safe: 1]?.frame.origin.x, 3)
    }

    func testColumnHeaderXForEmotionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            viewSize: Size(width: 10)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.x, 3)
        expect(view?.columnHeaders[safe: 1]?.frame.origin.x, 3 + 10)
    }

    func testColumnHeaderXForEmotionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 1)),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            viewSize: Size(width: 10)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.x, 3 - 10)
        expect(view?.columnHeaders[safe: 1]?.frame.origin.x, 3)
    }

    func testColumnHeaderYForAllMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.y, 2)
    }

    func testColumnHeaderYForSectionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            headerSize: Size(height: 2)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.y, -2)
    }

    func testColumnHeaderYForSectionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 3
            ),
            contentPadding: 4,
            headerSize: Size(height: 5),
            viewSize: Size(height: 10)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.y, -5 - (10 - 4 + 3))
    }

    func testColumnHeaderYForSectionMode3() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 0
            ),
            contentPadding: 4,
            headerSize: Size(height: 5),
            viewSize: Size(height: 10)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.y, -5 - (10 - 4 + 2))
    }

    func testColumnHeaderYForEmotionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            headerSize: Size(height: 10)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.y, -10)
    }

    func testColumnHeaderYForEmotionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 1, section: 0)),
                itemsPerSection: [2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 4
            ),
            contentPadding: 5,
            headerSize: Size(height: 6),
            viewSize: Size(height: 10)
        ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.y, -6 - (10 - 5 + 4))
    }

    func testColumnHeaderYForEmotionMode3() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 1, section: 0)),
                itemsPerSection: [2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 0
            ),
            contentPadding: 5,
            headerSize: Size(height: 6),
            viewSize: Size(height: 10)
            ))
        expect(view?.columnHeaders[safe: 0]?.frame.origin.y, -6 - (10 - 5 + 3))
    }

    func testRowHeaderFrameCount() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 1
            )
        ))
        expect(view?.rowHeaders.count, 2)
    }

    func testRowHeaderWidth() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            headerSize: Size(width: 2)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.size.width, 2)
    }

    func testRowHeaderHeightForAllModeWhenNotCompact() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            itemHeight: 2,
            minViewHeightForCompactLayout: 101,
            viewSize: Size(height: 100)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.size.height, 2)
    }

    func testSecondRowHeaderHeightForAllModeWhenNotCompact() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 1
            ),
            itemHeight: 2,
            minViewHeightForCompactLayout: 101,
            viewSize: Size(height: 100)
        ))
        expect(view?.rowHeaders[safe: 1]?.frame.size.height, 2)
    }

    func testRowHeaderHeightForAllModeWhenCompact() {
        let view = expectView(presenting: .init(
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
        ))
        let expected = (10 - (2 + 2 + 3 + 4)) / 1
        expect(view?.rowHeaders[safe: 0]?.frame.size.height, expected)
    }

    func testSecondRowHeaderHeightForAllModeWhenCompact() {
        let view = expectView(presenting: .init(
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
        ))
        let expected = (10 - (2 + 2 + 3 + 4 + 4)) / 2
        expect(view?.rowHeaders[safe: 1]?.frame.size.height, expected)
    }

    func testRowHeaderHeightForSectionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            viewSize: Size(height: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.size.height, 10 - 2 - 2)
    }

    func testRowHeaderHeightForEmotionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            viewSize: Size(height: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.size.height, 10 - 2 - 2)
    }

    func testRowHeaderXForAllMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.x, 2)
    }

    func testRowHeaderXForSectionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            headerSize: Size(width: 2)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.x, -2)
    }

    func testRowHeaderXForSectionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            headerSize: Size(width: 3),
            viewSize: Size(width: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.x, -3 - 10)
    }

    func testRowHeaderXForEmotionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            headerSize: Size(width: 2)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.x, -2)
    }

    func testRowHeaderXForEmotionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 1)),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            headerSize: Size(width: 3),
            viewSize: Size(width: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.x, -3 - 10)
    }

    func testRowHeaderYForAllModeWhenNotCompact() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, 2 + 3 + 4)
    }

    func testSecondRowHeaderYForAllModeWhenNotCompact() {
        let view = expectView(presenting: .init(
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
        ))
        let expected = 2 + 3 + 4 + 5 + 4
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, expected)
    }

    func testRowHeaderYForAllModeWhenCompact() {
        let view = expectView(presenting: .init(
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
        ))
        let expected = 2 + 3 + 4
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, expected)
    }

    func testSecondRowHeaderYForAllModeWhenCompact() {
        let view = expectView(presenting: .init(
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
        ))
        let expectedRowHeight = (20 - (2 + 2 + 3 + 4 + 4)) / 2
        let expected = 2 + 3 + 4 + expectedRowHeight + 4
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, expected)
    }

    func testRowHeaderYForSectionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 3
            ),
            contentPadding: 4,
            viewSize: Size(height: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, 4)
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, 10 - 4 + 3 + 4)
    }

    func testRowHeaderYForSectionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 0
            ),
            contentPadding: 4,
            viewSize: Size(height: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, 4)
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, 10 - 4 + 2 + 4)
    }

    func testRowHeaderYForSectionMode3() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 3
            ),
            contentPadding: 4,
            viewSize: Size(height: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, 4 - 3 - 10 + 4)
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, 4)
    }

    func testRowHeaderYForSectionMode4() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 0
            ),
            contentPadding: 4,
            viewSize: Size(height: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, 4 - 2 - 10 + 4)
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, 4)
    }

    func testRowHeaderYForEmotionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 3
            ),
            contentPadding: 4,
            viewSize: Size(height: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, 4)
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, 10 - 4 + 3 + 4)
    }

    func testRowHeaderYForEmotionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 0
            ),
            contentPadding: 4,
            viewSize: Size(height: 10)
            ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, 4)
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, 10 - 4 + 2 + 4)
    }

    func testRowHeaderYForEmotionMode3() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 1)),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 3
            ),
            contentPadding: 4,
            viewSize: Size(height: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, 4 - 3 - 10 + 4)
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, 4)
    }

    func testRowHeaderYForEmotionMode4() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 1)),
                itemsPerSection: [1, 1],
                numberOfColumns: 1,
                topContentInset: 2,
                bottomContentInset: 0
            ),
            contentPadding: 4,
            viewSize: Size(height: 10)
        ))
        expect(view?.rowHeaders[safe: 0]?.frame.origin.y, 4 - 2 - 10 + 4)
        expect(view?.rowHeaders[safe: 1]?.frame.origin.y, 4)
    }

    func testItemHeightForAllModeWhenNotCompact() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            itemHeight: 2,
            minViewHeightForCompactLayout: 11,
            viewSize: Size(height: 10)
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.size.height, 2)
    }

    func testItemHeightForAllModeWhenCompact1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4),
            minViewHeightForCompactLayout: 100,
            viewSize: Size(height: 100)
        ))
        let expected = 100 - (2 + 2 + 3 + 4)
        expect(view?.items[safe: 0]?[safe: 0]?.frame.size.height, expected)
    }

    func testItemHeightForAllModeWhenCompact2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            minViewHeightForCompactLayout: 100,
            viewSize: Size(height: 100)
        ))
        let expected = Int(round(Double(100 - (3 + 3 + 4 + 5)) / Double(2)))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.size.height, expected)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.size.height, expected)
    }

    func testItemHeightForSectionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 3,
            itemSpacing: 4,
            viewSize: Size(height: 100)
        ))
        let expected = Int(round(Double(100 - (3 + 3 + 4)) / Double(2)))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.size.height, expected)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.size.height, expected)
    }

    func testItemHeightForEmotionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 3,
            viewSize: Size(height: 100)
        ))
        let expected = 100 - 3 - 3
        expect(view?.items[safe: 0]?[safe: 0]?.frame.size.height, expected)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.size.height, expected)
    }

    func testItemWidthForAllMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(width: 3),
            sectionSpacing: Size(width: 4),
            viewSize: Size(width: 20)
        ))
        let expected = 20 - (2 + 2 + 3 + 4)
        expect(view?.items[safe: 0]?[safe: 0]?.frame.size.width, expected)
    }

    func testItemWidthForSectionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            viewSize: Size(width: 20)
        ))
        let expected = 20 - (2 + 2)
        expect(view?.items[safe: 0]?[safe: 0]?.frame.size.width, expected)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.size.width, expected)
    }

    func testItemWidthForEmotionMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            viewSize: Size(width: 20)
        ))
        let expected = 20 - (2 + 2)
        expect(view?.items[safe: 0]?[safe: 0]?.frame.size.width, expected)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.size.width, expected)
    }

    func testItemXForAllMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            headerSize: Size(width: 4),
            sectionSpacing: Size(width: 5),
            viewSize: Size(width: 20)
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.x, 3 + 4 + 5)
        let expectedItemWidth = (20 - (3 + 3 + 5 + 5 + 4)) / 2
        let expected = 3 + 4 + 5 + expectedItemWidth + 5
        expect(view?.items[safe: 1]?[safe: 0]?.frame.origin.x, expected)
    }

    func testItemXForSectionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            viewSize: Size(width: 20)
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.x, 3)
        expect(view?.items[safe: 1]?[safe: 0]?.frame.origin.x, 20 + 3)
    }

    func testItemXForSectionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            viewSize: Size(width: 20)
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.x, 3 - 20)
        expect(view?.items[safe: 1]?[safe: 0]?.frame.origin.x, 3)
    }

    func testItemXForEmotionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            viewSize: Size(width: 20)
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.x, 3)
        expect(view?.items[safe: 1]?[safe: 0]?.frame.origin.x, 20 + 3)
    }

    func testItemXForEmotionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 1)),
                itemsPerSection: [1, 1],
                numberOfColumns: 2
            ),
            contentPadding: 3,
            viewSize: Size(width: 20)
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.x, 3 - 20)
        expect(view?.items[safe: 1]?[safe: 0]?.frame.origin.x, 3)
    }

    func testItemYForAllMode() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            ),
            contentPadding: 2,
            headerSize: Size(height: 3),
            sectionSpacing: Size(height: 4)
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.y, 2 + 3 + 4)
    }

    func testSecondItemYForAllModeWhenNotCompact() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            itemHeight: 6,
            minViewHeightForCompactLayout: 21,
            viewSize: Size(height: 20)
        ))
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, 3 + 4 + 5 + 6)
    }

    func testSecondItemYForAllModeWhenCompact() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [2],
                numberOfColumns: 1
            ),
            contentPadding: 3,
            headerSize: Size(height: 4),
            sectionSpacing: Size(height: 5),
            itemHeight: 6,
            minViewHeightForCompactLayout: 20,
            viewSize: Size(height: 20)
        ))
        let expectedItemHeight = Int(round(Double(20 - (3 + 3 + 4 + 5)) / Double(2)))
        let expected = 3 + 4 + 5 + expectedItemHeight
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, expected)
    }

    func testItemYForSectionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [2, 2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 4
            ),
            contentPadding: 5,
            itemSpacing: 6,
            viewSize: Size(height: 20)
        ))
        let expectedItemHeight = Int(round(Double(20 - (5 + 5 + 6)) / Double(2)))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.y, 5)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, 5 + expectedItemHeight + 6)
        expect(view?.items[safe: 1]?[safe: 0]?.frame.origin.y, 5 + expectedItemHeight + 6 + expectedItemHeight + 5 + 4)
        expect(view?.items[safe: 1]?[safe: 1]?.frame.origin.y, 5 + expectedItemHeight + 6 + expectedItemHeight + 5 + 4 + expectedItemHeight + 6)
    }

    func testItemYForSectionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [2, 2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 0
            ),
            contentPadding: 5,
            itemSpacing: 6,
            viewSize: Size(height: 20)
        ))
        let expectedItemHeight = Int(round(Double(20 - (5 + 5 + 6)) / Double(2)))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.y, 5)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, 5 + expectedItemHeight + 6)
        expect(view?.items[safe: 1]?[safe: 0]?.frame.origin.y, 5 + expectedItemHeight + 6 + expectedItemHeight + 5 + 3)
        expect(view?.items[safe: 1]?[safe: 1]?.frame.origin.y, 5 + expectedItemHeight + 6 + expectedItemHeight + 5 + 3 + expectedItemHeight + 6)
    }

    func testItemYForSectionMode3() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [2, 2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 4
            ),
            contentPadding: 5,
            itemSpacing: 6,
            viewSize: Size(height: 20)
        ))
        let expectedItemHeight = Int(round(Double(20 - (5 + 5 + 6)) / Double(2)))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.y, -4 - expectedItemHeight - 6 - expectedItemHeight)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, -4 - expectedItemHeight)
        expect(view?.items[safe: 1]?[safe: 0]?.frame.origin.y, 5)
        expect(view?.items[safe: 1]?[safe: 1]?.frame.origin.y, 5 + expectedItemHeight + 6)
    }

    func testItemYForSectionMode4() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(1),
                itemsPerSection: [2, 2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 0
            ),
            contentPadding: 5,
            itemSpacing: 6,
            viewSize: Size(height: 20)
            ))
        let expectedItemHeight = Int(round(Double(20 - (5 + 5 + 6)) / Double(2)))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.y, -3 - expectedItemHeight - 6 - expectedItemHeight)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, -3 - expectedItemHeight)
        expect(view?.items[safe: 1]?[safe: 0]?.frame.origin.y, 5)
        expect(view?.items[safe: 1]?[safe: 1]?.frame.origin.y, 5 + expectedItemHeight + 6)
    }

    func testItemYForEmotionMode1() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 4
            ),
            contentPadding: 5,
            viewSize: Size(height: 20)
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.y, 5)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, 20 - 5 + 5 + 4)
    }

    func testItemYForEmotionMode2() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 0
            ),
            contentPadding: 5,
            viewSize: Size(height: 20)
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.y, 5)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, 20 - 5 + 5 + 3)
    }

    func testItemYForEmotionMode3() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 1, section: 0)),
                itemsPerSection: [2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 4
            ),
            contentPadding: 5,
            viewSize: Size(height: 20)
        ))
        let expectedItemHeight = 20 - 5 - 5
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.y, -4 - expectedItemHeight)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, 5)
    }

    func testItemYForEmotionMode4() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 1, section: 0)),
                itemsPerSection: [2],
                numberOfColumns: 1,
                topContentInset: 3,
                bottomContentInset: 0
            ),
            contentPadding: 5,
            viewSize: Size(height: 20)
        ))
        let expectedItemHeight = 20 - 5 - 5
        expect(view?.items[safe: 0]?[safe: 0]?.frame.origin.y, -3 - expectedItemHeight)
        expect(view?.items[safe: 0]?[safe: 1]?.frame.origin.y, 5)
    }

    func testHeadersAlphaWhenModeAllAndNotFocused() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [1],
                numberOfColumns: 1
            )
        ))
        expect(view?.columnHeaders[safe: 0]?.alpha, 1)
        expect(view?.rowHeaders[safe: 0]?.alpha, 1)
    }

    func testHeadersAlphaWhenModeSection() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [1],
                numberOfColumns: 1
            )
        ))
        expect(view?.columnHeaders[safe: 0]?.alpha, 0)
        expect(view?.rowHeaders[safe: 0]?.alpha, 0)
    }

    func testHeadersAlphaWhenModeEmotion() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 0, section: 0)),
                itemsPerSection: [1],
                numberOfColumns: 1
            )
        ))
        expect(view?.columnHeaders[safe: 0]?.alpha, 0)
        expect(view?.rowHeaders[safe: 0]?.alpha, 0)
    }

    func testItemsAlphaWhenModeAllAndFocused() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [2, 2]
            ),
            isFocused: true
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.alpha, 1)
        expect(view?.items[safe: 0]?[safe: 1]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 0]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 1]?.alpha, 1)
    }

    func testItemsAlphaWhenModeAllAndNotFocused() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .all,
                itemsPerSection: [2, 2]
            ),
            isFocused: false
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.alpha, 1)
        expect(view?.items[safe: 0]?[safe: 1]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 0]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 1]?.alpha, 1)
    }

    func testItemsAlphaWhenModeSectionAndFocused() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [2, 2]
            ),
            isFocused: true
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.alpha, 1)
        expect(view?.items[safe: 0]?[safe: 1]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 0]?.alpha, 0)
        expect(view?.items[safe: 1]?[safe: 1]?.alpha, 0)
    }

    func testItemsAlphaWhenModeSectionAndNotFocused() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .section(0),
                itemsPerSection: [2, 2]
            ),
            isFocused: false
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.alpha, 1)
        expect(view?.items[safe: 0]?[safe: 1]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 0]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 1]?.alpha, 1)
    }

    func testItemsAlphaWhenModeEmotionAndFocused() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 1, section: 0)),
                itemsPerSection: [2, 2]
            ),
            isFocused: true
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.alpha, 0)
        expect(view?.items[safe: 0]?[safe: 1]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 0]?.alpha, 0)
        expect(view?.items[safe: 1]?[safe: 1]?.alpha, 0)
    }

    func testItemsAlphaWhenModeEmotionAndNotFocused() {
        let view = expectView(presenting: .init(
            flags: .init(
                mode: .emotion(.init(item: 1, section: 0)),
                itemsPerSection: [2, 2]
            ),
            isFocused: false
        ))
        expect(view?.items[safe: 0]?[safe: 0]?.alpha, 1)
        expect(view?.items[safe: 0]?[safe: 1]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 0]?.alpha, 1)
        expect(view?.items[safe: 1]?[safe: 1]?.alpha, 1)
    }

    func testViewHeadersAt1() {
        let view = expectView(presenting: .init(
            flags: .init(
                itemsPerSection: [1, 2, 3],
                numberOfColumns: 3
            )
            ))
        let indexPaths: [IndexPath] = [
            .init(item: 0, section: 0), .init(item: 0, section: 1), .init(item: 0, section: 2),
            .init(item: 1, section: 0), .init(item: 1, section: 1), .init(item: 1, section: 2)
        ]
        let columnHeaders = indexPaths.flatMap { indexPath in
            view?.columnHeaderAt(item: indexPath.item, section: indexPath.section)
        }
        let rowHeaders = indexPaths.flatMap { indexPath in
            view?.rowHeaderAt(item: indexPath.item, section: indexPath.section)
        }
        expect(columnHeaders.count, 3)
        expect(rowHeaders.count, 1)
    }

    func testViewHeadersAt2() {
        let view = expectView(presenting: .init(
            flags: .init(
                itemsPerSection: [1, 2, 3],
                numberOfColumns: 2
            )
        ))
        let indexPaths: [IndexPath] = [
            .init(item: 0, section: 0), .init(item: 0, section: 1),
            .init(item: 1, section: 0), .init(item: 1, section: 1),
            .init(item: 0, section: 2),
            .init(item: 1, section: 2)
        ]
        let columnHeaders = indexPaths.flatMap { indexPath in
            view?.columnHeaderAt(item: indexPath.item, section: indexPath.section)
        }
        let rowHeaders = indexPaths.flatMap { indexPath in
            view?.rowHeaderAt(item: indexPath.item, section: indexPath.section)
        }
        expect(columnHeaders.count, 2)
        expect(rowHeaders.count, 2)
    }

}

extension ChartLayoutModule.Flags {

    init(
        mode: ChartLayoutModule.Mode = .all,
        itemsPerSection: [Int] = [1],
        numberOfColumns: Int = 1,
        topContentInset: Int = 0,
        bottomContentInset: Int = 0
        ) {
        self.mode = mode
        self.itemsPerSection = itemsPerSection
        self.numberOfColumns = numberOfColumns
        self.topContentInset = topContentInset
        self.bottomContentInset = bottomContentInset
    }

}

extension ChartLayoutModule.Model {
    init(
        flags: ChartLayoutModule.Flags = .init(),
        contentPadding: Int = 10,
        headerSize: Size = Size(width: 30, height: 30),
        sectionSpacing: Size = Size(width: 5, height: 5),
        itemHeight: Int = 30,
        itemSpacing: Int = 10,
        minViewHeightForCompactLayout: Int = 554,
        viewSize: Size = .zero,
        isFocused: Bool = false
        ) {
        self.flags = flags
        self.contentPadding = contentPadding
        self.headerSize = headerSize
        self.sectionSpacing = sectionSpacing
        self.itemHeight = itemHeight
        self.itemSpacing = itemSpacing
        self.minViewHeightForCompactLayout = minViewHeightForCompactLayout
        self.viewSize = viewSize
        self.isFocused = isFocused
    }
}

extension Point {
    // swiftlint:disable:next variable_name
    init(x: Int = 0, y: Int = 0) {
        self.x = x
        self.y = y
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
