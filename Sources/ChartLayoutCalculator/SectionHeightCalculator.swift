public protocol SectionHeightCalculator {

    var itemSpacing: Float { get }
    var numberOfSections: Int { get }

    func itemHeight(forSection section: Int) -> Float
    func numberOfItems(inSection section: Int) -> Int

}

extension SectionHeightCalculator {

    func heightForSection(section: Int) -> Float {
        let itemCount = numberOfItems(inSection: section)
        let verticalItemSpacing = Float(itemCount - 1) * itemSpacing
        let totalItemHeights = Float(itemCount) * itemHeight(forSection: section)
        return totalItemHeights + verticalItemSpacing
    }

}

public extension SectionHeightCalculator {

    var maximumSectionHeight: Float {
        let sections = 0..<numberOfSections
        let sectionHeights = sections.map(heightForSection)
        return sectionHeights.max() ?? 0
    }

}
