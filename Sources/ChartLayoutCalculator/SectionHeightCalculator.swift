public protocol SectionHeightCalculator {

    func heightForSection(section: Int) -> Float
    var maximumSectionHeight: Float { get }

}

public extension SectionHeightCalculator where Self: DefaultSectionHeightCalculator {

    func heightForSection(section: Int) -> Float {
        let itemCount = numberOfItems(inSection: section)
        let verticalItemSpacing = Float(itemCount - 1) * itemSpacing
        let totalItemHeights = Float(itemCount) * itemHeight(forSection: section)
        return totalItemHeights + verticalItemSpacing
    }

    var maximumSectionHeight: Float {
        let sections = 0..<numberOfSections
        let sectionHeights = sections.map(heightForSection)
        return sectionHeights.max() ?? 0
    }

}

public typealias DefaultSectionHeightCalculator = SectionHeightCalculator
    & ChartDataProvider
    & ItemSpacingCalculator
    & ItemSizeCalculator
