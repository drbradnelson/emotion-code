protocol ChartLayoutColumnHeadersCalculatorInterface: class {

    var columnHeaders: [ChartLayoutCore.Header] { get }

    init(mode: ChartLayoutCore.Mode, numberOfColumns: Int, columnWidth: Int, columnHeaderHeight: Int, initialPosition: Point, horizontalSectionSpacing: Int)

}

final class ChartLayoutColumnHeadersCalculator: ChartLayoutColumnHeadersCalculatorInterface {

    typealias Mode = ChartLayoutCore.Mode
    typealias Header = ChartLayoutCore.Header

    private let mode: Mode
    private let numberOfColumns: Int
    private let columnWidth: Int
    private let columnHeaderHeight: Int
    private let initialPosition: Point
    private let horizontalSectionSpacing: Int

    init(mode: Mode, numberOfColumns: Int, columnWidth: Int, columnHeaderHeight: Int, initialPosition: Point, horizontalSectionSpacing: Int) {
        self.mode = mode
        self.numberOfColumns = numberOfColumns
        self.columnWidth = columnWidth
        self.columnHeaderHeight = columnHeaderHeight
        self.initialPosition = initialPosition
        self.horizontalSectionSpacing = horizontalSectionSpacing
    }

    private(set) lazy var columnHeaders: [Header] = {
        let columnsRange = 0..<self.numberOfColumns
        return columnsRange.map(self.header)
    }()

    private var alpha: Float {
        switch mode {
        case .all: return 1
        case .section, .emotion: return 0
        }
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
