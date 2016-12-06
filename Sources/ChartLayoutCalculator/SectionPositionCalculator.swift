public protocol SectionPositionCalculator {

    func yPosition(forSection section: Int) -> Float

}

public extension SectionPositionCalculator where Self: DefaultSectionPositionCalculator {

    func yPosition(forSection section: Int) -> Float {
        let row = section / Self.numberOfColumns
        let cumulativeContentHeight = maximumSectionHeight * Float(row)
        let cumulativeSpacingHeight = verticalSectionSpacing * Float(row)
        return columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + verticalSectionSpacing + contentPadding
    }

}

public typealias DefaultSectionPositionCalculator = SectionPositionCalculator
    & ContentPaddingProvider
    & NumberOfColumnsProvider
    & SectionHeightCalculator
    & SectionSpacingCalculator
    & HeaderSizeCalculator
