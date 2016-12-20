import XCTest
@testable import EmotionCode

final class DefaultModelTests: XCTestCase {

    func test() {
        let model = Model()

        XCTAssertEqual(model.mode, .all)
        XCTAssertTrue(model.itemsPerSection.isEmpty)
        XCTAssertEqual(model.viewSize, .zero)

        let expectedHeaderSize = Size(width: 30, height: 30)
        XCTAssertEqual(model.headerSize, expectedHeaderSize)

        XCTAssertEqual(model.baseItemHeight, 30)
    }

}
