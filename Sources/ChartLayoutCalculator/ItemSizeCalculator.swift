public protocol ItemSizeCalculator {

    func itemHeight(forSection section: Int) -> Float
    var itemWidth: Float { get }

}

public extension ItemSizeCalculator where Self: DefaultItemSizeCalculator {

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
            let totalAvailableWidth = viewWidth - contentPadding * 2 - rowHeaderSize.width - horizontalSectionSpacing
            let totalSpacingWidth = horizontalSectionSpacing * Float(Self.numberOfColumns - 1)
            let totalContentWidth = totalAvailableWidth - totalSpacingWidth
            return totalContentWidth / Float(Self.numberOfColumns)
        case .section, .emotion:
            return viewWidth - contentPadding * 2
        }
    }

}

public typealias DefaultItemSizeCalculator = ItemSizeCalculator
    & ChartModeProvider
    & ContentPaddingProvider
    & HeaderSizeCalculator
    & ItemSpacingCalculator
    & NumberOfColumnsProvider
    & NumberOfItemsInSectionProvider
    & SectionSpacingCalculator
    & ViewSizeProvider
