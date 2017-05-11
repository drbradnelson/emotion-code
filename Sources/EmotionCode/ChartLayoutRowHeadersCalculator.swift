protocol ChartLayoutRowHeadersCalculatorInterface: class {

    associatedtype Header
    associatedtype DataSource

    var rowHeaders: [Header] { get }

    init(dataSource: DataSource)

}

final class ChartLayoutRowHeadersCalculator: ChartLayoutRowHeadersCalculatorInterface {

    typealias Header = ChartLayoutCore.Header

    struct DataSource {
        let numberOfRows: Int
        let alpha: Float
        let sectionHeight: Int
        let contentPadding: Int
        let rowHeaderWidth: Int
        let columnHeaderHeight: Int
        let verticalSectionSpacing: Int
    }

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }

    var rowHeaders: [Header] {
        let rowsRange = 0..<dataSource.numberOfRows
        return rowsRange.map(header)
    }

    private let dataSource: DataSource

    private var headerSize: Size {
        return Size(width: dataSource.rowHeaderWidth, height: dataSource.sectionHeight)
    }

    private var initialYPosition: Int {
        return dataSource.contentPadding + dataSource.columnHeaderHeight + dataSource.verticalSectionSpacing
    }

    private var xPosition: Int {
        return dataSource.contentPadding
    }

    private func position(forRow row: Int) -> Point {
        let y = initialYPosition + row * (headerSize.height + dataSource.verticalSectionSpacing)
        return Point(x: xPosition, y: y)
    }

    private func frame(forRow row: Int) -> Rect {
        let position = self.position(forRow: row)
        return Rect(origin: position, size: headerSize)
    }

    private func header(forRow row: Int) -> Header {
        let frame = self.frame(forRow: row)
        return Header(frame: frame, alpha: dataSource.alpha)
    }

}
