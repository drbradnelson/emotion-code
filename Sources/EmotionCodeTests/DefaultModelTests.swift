import XCTest
@testable import EmotionCode

final class DefaultModelTests: XCTestCase {
        
    func testModeAll() {
        let model = Model()

        XCTAssertEqual(model.mode, .all)
        XCTAssertTrue(model.itemsPerSection.isEmpty)
        XCTAssertEqual(model.viewSize, .zero)

        XCTAssertEqual(model.contentPadding, 10)

        let expectedSectionSpacing = Size(width: 15, height: 15)
        XCTAssertEqual(model.sectionSpacing, expectedSectionSpacing)
        XCTAssertEqual(model.itemSpacing, 5)

        let expectedHeaderSize = Size(width: 30, height: 30)
        XCTAssertEqual(model.headerSize, expectedHeaderSize)

        XCTAssertEqual(model.baseItemHeight, 30)
    }

    func testModeSection() {
        var model = Model()
        model.mode = .section(0)

        XCTAssertEqual(model.contentPadding, 20)

        let expectedSectionSpacing = Size(width: 15, height: 20)
        XCTAssertEqual(model.sectionSpacing, expectedSectionSpacing)

        XCTAssertEqual(model.itemSpacing, 10)
    }

    func testModeEmotion() {
        var model = Model()
        model.mode = .emotion(IndexPath())

        XCTAssertEqual(model.contentPadding, 20)

        let expectedSectionSpacing = Size(width: 15, height: 20)
        XCTAssertEqual(model.sectionSpacing, expectedSectionSpacing)

        XCTAssertEqual(model.itemSpacing, expectedSectionSpacing.height)
    }
    
}
