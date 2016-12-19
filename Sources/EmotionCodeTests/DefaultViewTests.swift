import XCTest
@testable import EmotionCode

final class DefaultViewTests: XCTestCase {

    func test() {
        let model = Model()

        let view = Module.view(for: model)

        XCTAssertEqual(view.chartSize, .zero)
        XCTAssertNil(view.proposedVerticalContentOffset)
        XCTAssertTrue(view.itemFrames.isEmpty)
        XCTAssertTrue(view.columnHeaderFrames.isEmpty)
        XCTAssertTrue(view.rowHeaderFrames.isEmpty)
        XCTAssertEqual(View.numberOfColumns, 2)
    }

}
