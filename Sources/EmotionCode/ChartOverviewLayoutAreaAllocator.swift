import Foundation
import UIKit


final class ChartOverviewLayoutAreaAllocator {

    let areaWidth: CGFloat
    var areaCurrentHeight: CGFloat = 0

    init(areaWidth: CGFloat) {
        self.areaWidth = areaWidth
    }

    func allocateArea(withHeight height: CGFloat) -> CGRect {
        let startY = self.areaCurrentHeight
        self.areaCurrentHeight += height

        let area = CGRect.init(x: 0, y: startY, width: self.areaWidth, height: height)
        return area
    }

    func allocatedArea() -> CGRect {
        return CGRect.init(x: 0, y: 0, width: areaWidth, height: areaCurrentHeight)
    }
}
