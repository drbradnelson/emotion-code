import XCTest
@testable import EmotionCode

final class DefaultModelTests: XCTestCase {

    func test() {
        XCTAssertEqual(Model(), Model(mode: .all, itemsPerSection: [], viewSize: .zero))
    }

}
