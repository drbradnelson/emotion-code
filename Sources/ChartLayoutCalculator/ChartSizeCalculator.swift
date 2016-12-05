public protocol ChartSizeCalculator {

    var mode: ChartLayoutMode { get }

    var maximumSectionHeight: Float { get }
    var contentPadding: Float { get }
    var verticalSectionSpacing: Float { get }
    var rowHeaderSize: Size { get }

    func yPosition(forSection section: Int) -> Float

    static var numberOfColumns: Int { get }

    var viewWidth: Float { get }
    var numberOfSections: Int { get }

}

public extension ChartSizeCalculator {

    var chartSize: Size {
        let lastSection = numberOfSections - 1
        let collectionViewContentHeight = yPosition(forSection: lastSection) + maximumSectionHeight
        let height = collectionViewContentHeight + verticalSectionSpacing + contentPadding
        let width: Float
        switch mode {
        case .all:
            width = viewWidth
        case .group, .emotion:
            width = viewWidth * Float(Self.numberOfColumns) - contentPadding + rowHeaderSize.width
        }
        return Size(width: width, height: height)
    }

}
