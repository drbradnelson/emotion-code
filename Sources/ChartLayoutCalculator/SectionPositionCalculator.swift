public protocol SectionPositionCalculator {

    var maximumSectionHeight: Float { get }
    var verticalSectionSpacing: Float { get }
    var columnHeaderSize: Size { get }
    var contentPadding: Float { get }

    static var numberOfColumns: Int { get }

}

public extension SectionPositionCalculator {

    func yPosition(forSection section: Int) -> Float {
        let row = section / Self.numberOfColumns
        let cumulativeContentHeight = maximumSectionHeight * Float(row)
        let cumulativeSpacingHeight = verticalSectionSpacing * Float(row)
        return columnHeaderSize.height + cumulativeSpacingHeight + cumulativeContentHeight + verticalSectionSpacing + contentPadding
    }

}
