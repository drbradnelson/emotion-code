// MARK: Chart

struct Chart {

    struct Row {
        let sections: [Section]
    }

    struct Section {
        let items: [Item]
    }

    struct Item {
        let title: String
        let description: String
    }

    let rows: [Row]

    var sections: [Section] {
        return rows.flatMap { row in row.sections }
    }

}
