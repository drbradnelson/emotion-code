import UIKit

final class ChartRowDetailsAccessibilityController {}

// MARK: Setup Accessibility

extension ChartRowDetailsAccessibilityController {

    static func setupAccessibilit(forChartOverviewView view: UIView) {
        view.accessibilityIdentifier = self.chartRowDetailsViewIdentifier
    }

    static func setupAccessibility(forRowCounterView view: UIView, atRowIndex rowIndex: Int) {
        let idenitifer = "\(self.rowCellIdentifierPrefix)_\(rowIndex)"
        view.accessibilityIdentifier = idenitifer
    }

}

// MARK: Constants

private extension ChartRowDetailsAccessibilityController {
    static let chartRowDetailsViewIdentifier = "ChartRowDetailsView"
    static let rowCellIdentifierPrefix = "RowCell"
}
