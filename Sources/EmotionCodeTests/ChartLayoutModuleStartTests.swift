import XCTest
import Elm

@testable import EmotionCode

// swiftlint:disable type_body_length

final class ChartLayoutModuleStartTests: XCTestCase, StartTests {

    var fixture = StartFixture<ChartLayoutModule>()
    let failureReporter = XCTFail

    func testLoadFlags1() {
        flags = .init(mode: .section(1), itemsPerSection: [2, 3], numberOfColumns: 4, topContentInset: 5)
        expect(model.flags, flags)
    }

    func testLoadFlags2() {
        flags = .init(mode: .section(5), itemsPerSection: [4, 3], numberOfColumns: 2, topContentInset: 1)
        expect(model.flags, flags)
    }

    func testLoadInvalidItemsPerSection() {
        flags = .init(itemsPerSection: [])
        expect(failure, .missingItems)
    }

    func testSetNumberOfColumnsInvalid1() {
        flags = .init(numberOfColumns: 0)
        expect(failure, .invalidNumberOfColums)
    }

    func testSetNumberOfColumnsInvalid2() {
        flags = .init(numberOfColumns: -1)
        expect(failure, .invalidNumberOfColums)
    }

    func testSetNumberOfColumnsInvalid3() {
        flags = .init(numberOfColumns: -2)
        expect(failure, .invalidNumberOfColums)
    }

}
