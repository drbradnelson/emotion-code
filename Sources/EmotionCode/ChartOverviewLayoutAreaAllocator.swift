import UIKit

final class ChartOverviewLayoutAreaAllocator {

    let insets: UIEdgeInsets
    let areaWidth: CGFloat
    var areaCurrentHeight: CGFloat

    init(areaWidth: CGFloat, andInsets insets: UIEdgeInsets) {
        self.areaWidth = areaWidth
        self.insets = insets
        areaCurrentHeight = insets.top
    }

    func allocateArea(withHeight height: CGFloat) -> CGRect {
        let startY = areaCurrentHeight
        areaCurrentHeight += height

        let area = CGRect.init(x: insets.left, y: startY, width: areaWidth - insets.right - insets.right, height: height)
        return area
    }

    func allocatedArea() -> CGRect {
        return CGRect.init(x: 0, y: 0, width: areaWidth, height: areaCurrentHeight + insets.bottom)
    }
}
