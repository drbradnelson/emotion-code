// MARK: Chart

struct Chart {

    struct Row {
        let columns: [Column]
    }

    struct Column {
        let items: [Item]
    }

    struct Item {
        let title: String
        let description: String
    }

    let rows: [Row]

    var columns: [Column] {
        return rows.flatMap { row in row.columns }
    }

}
