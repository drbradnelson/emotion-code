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
        let rowHeaderWidth: Int
        let rowHeight: Int
        let initialPosition: Point
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
        return Size(width: dataSource.rowHeaderWidth, height: dataSource.rowHeight)
    }

    private func position(forRow row: Int) -> Point {
        let x = dataSource.initialPosition.x
        let y = dataSource.initialPosition.y + row * (headerSize.height + dataSource.verticalSectionSpacing)
        return Point(x: x, y: y)
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
