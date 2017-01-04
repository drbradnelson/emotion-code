import XCTest
import Elm

@testable import EmotionCode

// swiftlint:disable type_body_length

final class ChartLayoutModuleUpdateTests: XCTestCase, UpdateTests {

    var fixture = UpdateFixture<ChartLayoutModule>()
    let failureReporter = XCTFail

    func testSetViewSize1() {
        model = .init()
        message = .setViewSize(Size(width: 1, height: 2))
        expect(model.viewSize, Size(width: 1, height: 2))
    }

    func testSetViewSize2() {
        model = .init()
        message = .setViewSize(Size(width: 3, height: 4))
        expect(model.viewSize, Size(width: 3, height: 4))
    }

    func testSetViewSizeInvalid1() {
        model = .init()
        message = .setViewSize(Size(width: 0, height: 10))
        expect(failure, .invalidViewSize)
    }

    func testSetViewSizeInvalid2() {
        model = .init()
        message = .setViewSize(Size(width: -1, height: 10))
        expect(failure, .invalidViewSize)
    }

    func testSetViewSizeInvalid3() {
        model = .init()
        message = .setViewSize(Size(width: 10, height: 0))
        expect(failure, .invalidViewSize)
    }

    func testSetViewSizeInvalid4() {
        model = .init()
        message = .setViewSize(Size(width: 10, height: -1))
        expect(failure, .invalidViewSize)
    }

}
