protocol ChartLayoutColumnHeadersCalculatorInterface: class {

    associatedtype Header

    var columnHeaders: [Header] { get }

    init(numberOfColumns: Int, alpha: Float, columnWidth: Int, contentPadding: Int, rowHeaderWidth: Int, columnHeaderHeight: Int, horizontalSectionSpacing: Int)

}

final class ChartLayoutColumnHeadersCalculator: ChartLayoutColumnHeadersCalculatorInterface {

    typealias Header = ChartLayoutCore.Header

    private let numberOfColumns: Int
    private let alpha: Float
    private let columnWidth: Int
    private let contentPadding: Int
    private let rowHeaderWidth: Int
    private let columnHeaderHeight: Int
    private let horizontalSectionSpacing: Int

    init(numberOfColumns: Int, alpha: Float, columnWidth: Int, contentPadding: Int, rowHeaderWidth: Int, columnHeaderHeight: Int, horizontalSectionSpacing: Int) {
        self.numberOfColumns = numberOfColumns
        self.alpha = alpha
        self.columnWidth = columnWidth
        self.contentPadding = contentPadding
        self.rowHeaderWidth = rowHeaderWidth
        self.columnHeaderHeight = columnHeaderHeight
        self.horizontalSectionSpacing = horizontalSectionSpacing
    }

    var columnHeaders: [Header] {
        return columnsRange.map(header)
    }

    private var columnsRange: CountableRange<Int> {
        return 0..<numberOfColumns
    }

    private var headerSize: Size {
        return Size(width: columnWidth, height: columnHeaderHeight)
    }

    private var initialXPosition: Int {
        return contentPadding + rowHeaderWidth + horizontalSectionSpacing
    }

    private var yPosition: Int {
        return contentPadding
    }

    private func position(forColumn column: Int) -> Point {
        let x = initialXPosition + column * (headerSize.width + horizontalSectionSpacing)
        return Point(x: x, y: yPosition)
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
