public protocol ItemSizeCalculator {

    var mode: ChartLayoutMode { get }

    var itemSpacing: Float { get }
    var contentPadding: Float { get }
    var rowHeaderSize: Size { get }
    var visibleContentHeight: Float { get }
    var viewWidth: Float { get }

    static var horizontalSectionSpacing: Float { get }
    static var numberOfColumns: Int { get }

    func numberOfItems(inSection section: Int) -> Int

}

public extension ItemSizeCalculator {

    func itemHeight(forSection section: Int) -> Float {
        switch mode {
        case .all: return 30
        case .section:
            let itemCount = numberOfItems(inSection: section)
            let totalPaddingHeight = contentPadding * 2
            let totalSpacingHeight = itemSpacing * Float(itemCount - 1)
            let totalAvailableContentHeight = visibleContentHeight - totalPaddingHeight - totalSpacingHeight
            return totalAvailableContentHeight / Float(itemCount)
        case .emotion:
            let totalPaddingHeight = contentPadding * 2
            let totalAvailableContentHeight = visibleContentHeight - totalPaddingHeight
            return totalAvailableContentHeight
        }
    }

    var itemWidth: Float {
        switch mode {
        case .all:
            let totalAvailableWidth = viewWidth - contentPadding * 2 - rowHeaderSize.width - Self.horizontalSectionSpacing
            let totalSpacingWidth = Self.horizontalSectionSpacing * Float(Self.numberOfColumns - 1)
            let totalContentWidth = totalAvailableWidth - totalSpacingWidth
            return totalContentWidth / Float(Self.numberOfColumns)
        case .section, .emotion:
            return viewWidth - contentPadding * 2
        }
    }

}
