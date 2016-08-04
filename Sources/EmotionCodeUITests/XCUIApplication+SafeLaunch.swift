import XCTest

extension XCUIApplication {

    func safeLaunch(clean clean: Bool = false) {
        launch()
        sleep(1)
    }

}
