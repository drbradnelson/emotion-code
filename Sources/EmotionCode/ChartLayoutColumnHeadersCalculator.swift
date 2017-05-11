protocol ChartLayoutColumnHeadersCalculatorInterface: class {

    associatedtype Header
    associatedtype DataSource

    var columnHeaders: [Header] { get }

    init(dataSource: DataSource)

}

final class ChartLayoutColumnHeadersCalculator: ChartLayoutColumnHeadersCalculatorInterface {

    typealias Header = ChartLayoutCore.Header

    struct DataSource {
        let numberOfColumns: Int
        let alpha: Float
        let columnWidth: Int
        let contentPadding: Int
        let rowHeaderWidth: Int
        let columnHeaderHeight: Int
        let horizontalSectionSpacing: Int
    }

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    var columnHeaders: [Header] {
        let columnsRange = 0..<dataSource.numberOfColumns
        return columnsRange.map(header)
    }

    private let dataSource: DataSource

    private var headerSize: Size {
        return Size(width: dataSource.columnWidth, height: dataSource.columnHeaderHeight)
    }

    private var initialXPosition: Int {
        return dataSource.contentPadding + dataSource.rowHeaderWidth + dataSource.horizontalSectionSpacing
    }

    private var yPosition: Int {
        return dataSource.contentPadding
    }

    private func position(forColumn column: Int) -> Point {
        let x = initialXPosition + column * (headerSize.width + dataSource.horizontalSectionSpacing)
        return Point(x: x, y: yPosition)
    }

    private func frame(forColumn column: Int) -> Rect {
        let position = self.position(forColumn: column)
        return Rect(origin: position, size: headerSize)
    }

    private func header(forColumn column: Int) -> Header {
        let frame = self.frame(forColumn: column)
        return Header(frame: frame, alpha: dataSource.alpha)
    }

}
