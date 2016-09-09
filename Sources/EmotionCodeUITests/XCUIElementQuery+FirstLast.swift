import XCTest

extension XCUIElementQuery {

    var first: XCUIElement {
        return elementBoundByIndex(0)
    }

    var last: XCUIElement {
        let lastElementIndex = UInt(allElementsBoundByIndex.count - 1)
        return elementBoundByIndex(lastElementIndex)
    }

}
