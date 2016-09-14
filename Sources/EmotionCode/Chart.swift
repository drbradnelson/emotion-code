// MARK: Chart

struct Chart {

    struct Column {
        let rows: [Row]
    }

    struct Row {
        let items: [Item]
    }

    struct Item {
        let title: String
        let description: String
    }

    let columns: [Column]

}
