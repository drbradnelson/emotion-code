import XCTest

// MARK: Main

final class BookLayoutTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
        sleep(1)
    }

}

// MARK: Tests

extension BookLayoutTests {

    func testWebViewFrame() {
        XCTAssertEqual(app.webViews.element.frame, app.mainWindow.frame)
    }

}
