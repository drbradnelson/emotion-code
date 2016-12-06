public protocol SectionPositions {

    func yPosition(forSection section: Int) -> Float

}

public extension SectionPositions where Self: DefaultSectionPositions {

    func yPosition(forSection section: Int) -> Float {
        let row = section / Self.numberOfColumns
        let cumulativeContentHeight = maximumSectionHeights * Float(row)
        let cumulativeSpacingHeight = verticalSectionSpacing * Float(row)
        return columnHeaderSizes.height + cumulativeSpacingHeight + cumulativeContentHeight + verticalSectionSpacing + contentPadding
    }

}

public typealias DefaultSectionPositions = SectionPositions
    & ContentPadding
    & NumberOfColumns
    & SectionHeights
    & SectionSpacing
    & HeaderSizes
