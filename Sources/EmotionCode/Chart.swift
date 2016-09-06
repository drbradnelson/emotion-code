// MARK: Main

struct Chart {

    let columns: [ChartColumn]
}

// MARK: Column

struct ChartColumn {

    let rows: [ChartRow]

}

// MARK: Row

struct ChartRow {

    let items: [ChartItem]

}

// MARK: Row Position

struct ChartRowPosition {

    let columnIndex: Int
    let rowIndex: Int


    init(column: Int, row: Int) {
        columnIndex = column
        rowIndex = row
    }

}

extension Chart {

    func row(forPosition rowPosition: ChartRowPosition) -> ChartRow {
        return self.columns[rowPosition.columnIndex].rows[rowPosition.rowIndex]
    }

}

// MARK: Item

struct ChartItem {

    let title: String
    let description: String

}

// MARK: Item Position

struct ChartItemPosition {

    let columnIndex: Int
    let rowIndex: Int
    let itemIndex: Int

    init(column: Int, row: Int, item: Int) {
        columnIndex = column
        rowIndex = row
        itemIndex = item
    }

}

extension Chart {

    func item(forPosition itemPosition: ChartItemPosition) -> ChartItem {
        return self.columns[itemPosition.columnIndex].rows[itemPosition.rowIndex].items[itemPosition.itemIndex]
    }

}
