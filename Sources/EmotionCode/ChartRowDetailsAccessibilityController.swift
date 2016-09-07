import UIKit

final class ChartRowDetailsAccessibilityController {

}

// MARK: Setup Accessibility

extension ChartRowDetailsAccessibilityController {
    static func setupAccessibilit(forChartOverviewView view: UIView) {
        view.accessibilityIdentifier = ChartOverviewAccessibilityController.chartOverviewViewIdentifier
    }

    static func setupAccessibility(forRowCounterView view: UIView, atRowIndex rowIndex: Int) {
        let idenitifer = "\(ChartRowDetailsAccessibilityController.rowCellIdentifierPrefix)_\(rowIndex)"
        view.accessibilityIdentifier = idenitifer
    }
}

// MARK: Constants

extension ChartRowDetailsAccessibilityController {
    static let chartOverviewViewIdentifier = "ChartRowDetailsView"
    static let rowCellIdentifierPrefix = "RowCell"
}
