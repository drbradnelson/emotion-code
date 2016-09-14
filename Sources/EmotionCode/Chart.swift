// MARK: Chart

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
