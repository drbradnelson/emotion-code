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

}
