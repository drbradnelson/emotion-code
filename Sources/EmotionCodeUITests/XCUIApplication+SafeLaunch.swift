import XCTest

extension XCUIApplication {

    func safeLaunch(clean: Bool = false) {
        launch()
        sleep(1)
    }

}
