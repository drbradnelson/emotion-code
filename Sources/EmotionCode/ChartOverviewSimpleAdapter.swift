import Foundation

final class ChartOverviewSimpleAdapter {

    private var chart: Chart
    init(chart: Chart) {
        self.chart = chart
    }
}

extension ChartOverviewSimpleAdapter : ChartOverviewCollectionLayoutDataAdapter {

    func numberOfColumns() -> Int {
        return chart.columns.count
    }

    func numberOfRows(forColumnIndex column: Int) -> Int {
        return chart.columns[column].rows.count
    }

    func numberOfItems(forColumnIndex column: Int, forRowIndex row: Int) -> Int {
        return chart.columns[column].rows[row].items.count
    }

    func numberOfItems(inSection section: Int) -> Int {
        return chart.columns.count
    }

    func numberOfSections() -> Int {
        var maxRowsCount = 0
        for columnPosition in 0 ..< numberOfColumns() {
            let rows = chart.columns[columnPosition].rows
            if maxRowsCount < rows.count {
                maxRowsCount = rows.count
            }
        }

        return maxRowsCount
    }

    func indexPath(forColumnIndex columnIndex: Int) -> NSIndexPath {
        return NSIndexPath.init(forItem: 0, inSection: columnIndex)
    }

    func columnIndex(forIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.section
    }

    func indexPath(forRowIndex rowIndex: Int) -> NSIndexPath {
        return NSIndexPath.init(forItem: 0, inSection: rowIndex)
    }

    func rowIndex(forIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.section
    }

    func indexPath(forRowPosition rowPosition: ChartRowPosition) -> NSIndexPath {
        return NSIndexPath.init(forItem: rowPosition.columnIndex, inSection: rowPosition.rowIndex)
    }

    func rowPosition(forIndexPath indexPath: NSIndexPath) -> ChartRowPosition {
        return ChartRowPosition.init(column: indexPath.item, row: indexPath.section)
    }
}
