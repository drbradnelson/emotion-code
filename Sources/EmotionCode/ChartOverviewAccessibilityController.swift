import UIKit

final class ChartOverviewAccessibilityController {}

// MARK: Setup Accessibility

extension ChartOverviewAccessibilityController {

    static func setupAccessibility(forChartOverviewView view: UIView) {
        view.accessibilityIdentifier = chartOverviewViewIdentifier
    }

    static func setupAccessibility(forColumnHeader view: UIView, forColumn column: ChartColumn, atIndex columnIndex: Int) {
        let identifier = "\(columnHeaderIdentifierPrefix)_\(columnIndex)"
        view.accessibilityIdentifier = identifier
    }

    static func setupAccessibility(forRowCounterView view: UIView, atRowIndex rowIndex: Int) {
        let identifier = "\(rowCounterIdentifierPrefix)_\(rowIndex)"
        view.accessibilityIdentifier = identifier
    }

    static func setupAccessibility(forRowCell view: UIView, forRow row: ChartRow, atRowPosition rowPosition: ChartRowPosition) {
        let identifier = "\(rowCellIdentifierPrefix)_\(rowPosition.columnIndex)_\(rowPosition.rowIndex)"
        view.accessibilityIdentifier = identifier
    }

}

// MARK: Constants

private extension ChartOverviewAccessibilityController {

    static let chartOverviewViewIdentifier = "ChartOverviewView"
    static let columnHeaderIdentifierPrefix = "ColumnHeader"
    static let rowCounterIdentifierPrefix = "RowCounter"
    static let rowCellIdentifierPrefix = "RowCell"

}
