public protocol SectionHeights {

    func heightForSection(section: Int) -> Float
    var maximumSectionHeights: Float { get }

}

public extension SectionHeights where Self: DefaultSectionHeights {

    func heightForSection(section: Int) -> Float {
        let itemCount = numberOfItems(inSection: section)
        let verticalItemSpacing = Float(itemCount - 1) * itemSpacing
        let totalItemHeights = Float(itemCount) * itemHeight(forSection: section)
        return totalItemHeights + verticalItemSpacing
    }

    var maximumSectionHeights: Float {
        let sections = 0..<numberOfSections
        let sectionHeights = sections.map(heightForSection)
        return sectionHeights.max() ?? 0
    }

}

public typealias DefaultSectionHeights = SectionHeights
    & ChartData
    & ItemSpacing
    & ItemSizes
