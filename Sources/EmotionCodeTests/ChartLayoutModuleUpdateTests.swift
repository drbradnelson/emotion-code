import XCTest
import Elm

@testable import EmotionCode

// swiftlint:disable type_body_length

final class ChartLayoutModuleUpdateTests: XCTestCase, Tests {

    typealias Module = ChartLayoutModule
    let failureReporter = XCTFail

    func testSetViewSize1() {
        // Add explicit viewSize
        let update = expectUpdate(for: .setViewSize(.init(width: 1, height: 2)), model: .init())
        expect(update?.model.viewSize, Size(width: 1, height: 2))
    }

    func testSetViewSize2() {
        // Add explicit viewSize
        let update = expectUpdate(for: .setViewSize(.init(width: 3, height: 4)), model: .init())
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

}
