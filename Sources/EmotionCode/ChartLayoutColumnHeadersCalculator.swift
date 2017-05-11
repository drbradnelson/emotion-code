protocol ChartLayoutColumnHeadersCalculatorInterface: class {

    associatedtype Header

    var columnHeaders: [Header] { get }

    init(numberOfColumns: Int, alpha: Float, columnWidth: Int, contentPadding: Int, rowHeaderWidth: Int, columnHeaderHeight: Int, horizontalSectionSpacing: Int)

}

final class ChartLayoutColumnHeadersCalculator: ChartLayoutColumnHeadersCalculatorInterface {

    typealias Header = ChartLayoutCore.Header
    private typealias Column = Int

    private let numberOfColumns: Int
    private let alpha: Float
    private let horizontalSectionSpacing: Int

    init(numberOfColumns: Int, alpha: Float, columnWidth: Int, contentPadding: Int, rowHeaderWidth: Int, columnHeaderHeight: Int, horizontalSectionSpacing: Int) {
        self.numberOfColumns = numberOfColumns
        self.alpha = alpha
        self.horizontalSectionSpacing = horizontalSectionSpacing

        headerSize = Size(width: columnWidth, height: columnHeaderHeight)
        initialXPosition = contentPadding + rowHeaderWidth + horizontalSectionSpacing
        yPosition = contentPadding
    }

    private let headerSize: Size
    private let initialXPosition: Int
    private let yPosition: Int

    var columnHeaders: [Header] {
        return (0..<numberOfColumns).map(header)
    }

    private func xPosition(for column: Column) -> Int {
        return initialXPosition + column * (headerSize.width + horizontalSectionSpacing)
    }

    private func position(for column: Column) -> Point {
        let x = xPosition(for: column)
        return Point(x: x, y: yPosition)
    }

    private func frame(for column: Column) -> Rect {
        let position = self.position(for: column)
        return Rect(origin: position, size: headerSize)
    }

    private func header(for column: Column) -> Header {
        let frame = self.frame(for: column)
        return Header(frame: frame, alpha: alpha)
    }
    
}
