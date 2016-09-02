import Foundation
import UIKit

final class ChartOverviewAccessibilityController {
}

// MARK: Setup Accessibility

extension ChartOverviewAccessibilityController {
    static func setupAccessibilit(forChartOverviewView view: UIView) {
        view.accessibilityIdentifier = ChartOverviewAccessibilityController.chartOverviewViewIdentifier
    }

    static func setupAccessibility(forColumnHeader view: UIView, forColumn column: ChartColumn, atIndex columnIndex: Int) {
        let idenitifer = "\(ChartOverviewAccessibilityController.columnHeaderIdentifierPrefix)_\(columnIndex)"
        view.accessibilityIdentifier = idenitifer
    }

    static func setupAccessibility(forRowCounterView view: UIView, atRowIndex rowIndex: Int) {
        let idenitifer = "\(ChartOverviewAccessibilityController.rowCounterIdentifierPrefix)_\(rowIndex)"
        view.accessibilityIdentifier = idenitifer
    }

    static func setupAccessibility(forRowCell view: UIView, forRow row: ChartRow, atRowPosition rowPosition: ChartRowPosition) {
        let idenitifer = "\(ChartOverviewAccessibilityController.rowCellIdentifierPrefix)_\(rowPosition.columnIndex)_\(rowPosition.rowIndex)"
        view.accessibilityIdentifier = idenitifer
    }
}

// MARK: Constants

extension ChartOverviewAccessibilityController {
    static let chartOverviewViewIdentifier = "ChartOverviewView"
    static let columnHeaderIdentifierPrefix = "ColumnHeader"
    static let rowCounterIdentifierPrefix = "RowCounter"
    static let rowCellIdentifierPrefix = "RowCell"
}
