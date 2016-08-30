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

// MARK: Item

struct ChartItem {

    let title: String
    let description: String

}

// MARK: Item Position

struct ChartItemPosition {
    let columnPosition: Int
    let rowPosition: Int
    let itemPosition: Int

    init(column: Int, row: Int, item: Int) {
        self.columnPosition = column
        self.rowPosition = row
        self.itemPosition = item
    }
}

extension Chart {
    
    func item(forPosition itemPosition: ChartItemPosition) -> ChartItem {
        return self.columns[itemPosition.columnPosition].rows[itemPosition.rowPosition].items[itemPosition.itemPosition]
    }
}

// MARK: Items Count

private extension Chart {

    var itemsCount: Int  {
        get {
            return self.calculateItemsCount()
        }
    }
    
    func calculateItemsCount() -> Int {
        var counter = 0
        
        self.columns.forEach { (column) in
            counter += column.rows.reduce(0, combine: { (itemsInRowCounter, row) -> Int in
                return itemsInRowCounter + row.items.count
            })
        }
        
        return counter
    }

}