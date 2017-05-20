protocol ChartLayoutColumnHeadersCalculatorInterface: class {

    associatedtype Header

    var columnHeaders: [Header] { get }

    init(numberOfColumns: Int, alpha: Float, columnWidth: Int, columnHeaderHeight: Int, initialPosition: Point, horizontalSectionSpacing: Int)

}

final class ChartLayoutColumnHeadersCalculator: ChartLayoutColumnHeadersCalculatorInterface {

    typealias Header = ChartLayoutCore.Header

    private let numberOfColumns: Int
    private let alpha: Float
    private let columnWidth: Int
    private let columnHeaderHeight: Int
    private let initialPosition: Point
    private let horizontalSectionSpacing: Int

    init(numberOfColumns: Int, alpha: Float, columnWidth: Int, columnHeaderHeight: Int, initialPosition: Point, horizontalSectionSpacing: Int) {
        self.numberOfColumns = numberOfColumns
        self.alpha = alpha
        self.columnWidth = columnWidth
        self.columnHeaderHeight = columnHeaderHeight
        self.initialPosition = initialPosition
        self.horizontalSectionSpacing = horizontalSectionSpacing
    }

    var columnHeaders: [Header] {
        let columnsRange = 0..<numberOfColumns
        return columnsRange.map(header)
    }

    private var headerSize: Size {
        return Size(width: columnWidth, height: columnHeaderHeight)
    }

    private func position(forColumn column: Int) -> Point {
        let x = initialPosition.x + column * (headerSize.width + horizontalSectionSpacing)
        let y = initialPosition.y
        return Point(x: x, y: y)
    }

    private func frame(forColumn column: Int) -> Rect {
        let position = self.position(forColumn: column)
        return Rect(origin: position, size: headerSize)
    }

    private func header(forColumn column: Int) -> Header {
        let frame = self.frame(forColumn: column)
        return Header(frame: frame, alpha: alpha)
    }

}
