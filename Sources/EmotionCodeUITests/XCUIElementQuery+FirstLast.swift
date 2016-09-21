import XCTest

extension XCUIElementQuery {

    var first: XCUIElement {
        return element(boundBy: 0)
    }

    var last: XCUIElement {
        let lastElementIndex = UInt(allElementsBoundByIndex.count - 1)
        return element(boundBy: lastElementIndex)
    }

}
