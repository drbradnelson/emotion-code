protocol ChartLayoutRowHeadersCalculatorInterface: class {

    associatedtype Header

    var rowHeaders: [Header] { get }

    init(numberOfRows: Int, alpha: Float, rowHeaderWidth: Int, rowHeight: Int, initialPosition: Point, verticalSectionSpacing: Int)

}

final class ChartLayoutRowHeadersCalculator: ChartLayoutRowHeadersCalculatorInterface {

    typealias Header = ChartLayoutCore.Header

    private let numberOfRows: Int
    private let alpha: Float
    private let rowHeaderWidth: Int
    private let rowHeight: Int
    private let initialPosition: Point
    private let verticalSectionSpacing: Int

    init(numberOfRows: Int, alpha: Float, rowHeaderWidth: Int, rowHeight: Int, initialPosition: Point, verticalSectionSpacing: Int) {
        self.numberOfRows = numberOfRows
        self.alpha = alpha
        self.rowHeaderWidth = rowHeaderWidth
        self.rowHeight = rowHeight
        self.initialPosition = initialPosition
        self.verticalSectionSpacing = verticalSectionSpacing
    }

    private(set) lazy var rowHeaders: [Header] = {
        let rowsRange = 0..<self.numberOfRows
        return rowsRange.map(self.header)
    }()

    private var headerSize: Size {
        return Size(width: rowHeaderWidth, height: rowHeight)
    }

    private func position(forRow row: Int) -> Point {
        let x = initialPosition.x
        let y = initialPosition.y + row * (headerSize.height + verticalSectionSpacing)
        return Point(x: x, y: y)
    }

    private func frame(forRow row: Int) -> Rect {
        let position = self.position(forRow: row)
        return Rect(origin: position, size: headerSize)
    }

    private func header(forRow row: Int) -> Header {
        let frame = self.frame(forRow: row)
        return Header(frame: frame, alpha: alpha)
    }

}
