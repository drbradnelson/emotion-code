import Foundation

// MARK: Main

final class ChartOverviewSimpleAdapter {

    private let chart: Chart

    init(chart: Chart) {
        self.chart = chart
    }

}

// MARK: Adapter methods

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
        return chart.columns.reduce(0, combine: { maxRowsCount, column -> Int in
            return maxRowsCount < column.rows.count ? column.rows.count : maxRowsCount
        })
    }

    func indexPath(forColumnIndex columnIndex: Int) -> NSIndexPath {
        return NSIndexPath(forItem: 0, inSection: columnIndex)
    }

    func columnIndex(forIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.section
    }

    func indexPath(forRowIndex rowIndex: Int) -> NSIndexPath {
        return NSIndexPath(forItem: 0, inSection: rowIndex)
    }

    func rowIndex(forIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.section
    }

    func indexPath(forRowPosition rowPosition: ChartRowPosition) -> NSIndexPath {
        return NSIndexPath(forItem: rowPosition.columnIndex, inSection: rowPosition.rowIndex)
    }

    func rowPosition(forIndexPath indexPath: NSIndexPath) -> ChartRowPosition {
        return ChartRowPosition(columnIndex: indexPath.item, rowIndex: indexPath.section)
    }

}
