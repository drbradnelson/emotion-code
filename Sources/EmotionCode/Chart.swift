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

}

extension Chart {

    func row(forPosition rowPosition: ChartRowPosition) -> ChartRow {
        return columns[rowPosition.columnIndex].rows[rowPosition.rowIndex]
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

}

extension Chart {

    func item(forPosition itemPosition: ChartItemPosition) -> ChartItem {
        return columns[itemPosition.columnIndex].rows[itemPosition.rowIndex].items[itemPosition.itemIndex]
    }

}
