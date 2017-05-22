protocol ChartLayoutRowHeadersCalculatorInterface: class {

    associatedtype Mode
    associatedtype Header

    var rowHeaders: [Header] { get }

    init(mode: Mode, numberOfRows: Int, rowHeaderWidth: Int, rowHeight: Int, initialPosition: Point, verticalSectionSpacing: Int)

}

final class ChartLayoutRowHeadersCalculator: ChartLayoutRowHeadersCalculatorInterface {

    typealias Header = ChartLayoutCore.Header
    typealias Mode = ChartLayoutCore.Mode

    private let mode: Mode
    private let numberOfRows: Int
    private let rowHeaderWidth: Int
    private let rowHeight: Int
    private let initialPosition: Point
    private let verticalSectionSpacing: Int

    init(mode: Mode, numberOfRows: Int, rowHeaderWidth: Int, rowHeight: Int, initialPosition: Point, verticalSectionSpacing: Int) {
        self.mode = mode
        self.numberOfRows = numberOfRows
        self.rowHeaderWidth = rowHeaderWidth
        self.rowHeight = rowHeight
        self.initialPosition = initialPosition
        self.verticalSectionSpacing = verticalSectionSpacing
    }

    private(set) lazy var rowHeaders: [Header] = {
        let rowsRange = 0..<self.numberOfRows
        return rowsRange.map(self.header)
    }()

    private var alpha: Float {
        switch mode {
        case .all: return 1
        case .section, .emotion: return 0
        }
    }

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
