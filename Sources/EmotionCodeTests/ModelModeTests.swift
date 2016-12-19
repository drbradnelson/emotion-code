import XCTest
@testable import EmotionCode

final class ModelModeTests: XCTestCase {

    func testModeAll() {
        let model = Model()

        XCTAssertEqual(model.contentPadding, 10)

        let expectedSectionSpacing = Size(width: 15, height: 15)
        XCTAssertEqual(model.sectionSpacing, expectedSectionSpacing)
        XCTAssertEqual(model.itemSpacing, 5)
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
