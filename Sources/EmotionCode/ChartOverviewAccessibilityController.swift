import UIKit

final class ChartOverviewAccessibilityController {}

// MARK: Setup Accessibility

extension ChartOverviewAccessibilityController {

    static func setupAccessibility(forChartOverviewView view: UIView) {
        view.accessibilityIdentifier = self.chartOverviewViewIdentifier
    }

    static func setupAccessibility(forColumnHeader view: UIView, forColumn column: ChartColumn, atIndex columnIndex: Int) {
        let idenitifer = "\(self.columnHeaderIdentifierPrefix)_\(columnIndex)"
        view.accessibilityIdentifier = idenitifer
    }

    static func setupAccessibility(forRowCounterView view: UIView, atRowIndex rowIndex: Int) {
        let idenitifer = "\(self.rowCounterIdentifierPrefix)_\(rowIndex)"
        view.accessibilityIdentifier = idenitifer
    }

    static func setupAccessibility(forRowCell view: UIView, forRow row: ChartRow, atRowPosition rowPosition: ChartRowPosition) {
        let idenitifer = "\(self.rowCellIdentifierPrefix)_\(rowPosition.columnIndex)_\(rowPosition.rowIndex)"
        view.accessibilityIdentifier = idenitifer
    }

}

// MARK: Constants

private extension ChartOverviewAccessibilityController {

    static let chartOverviewViewIdentifier = "ChartOverviewView"
    static let columnHeaderIdentifierPrefix = "ColumnHeader"
    static let rowCounterIdentifierPrefix = "RowCounter"
    static let rowCellIdentifierPrefix = "RowCell"

}
