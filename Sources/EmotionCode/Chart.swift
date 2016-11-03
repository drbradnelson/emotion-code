// MARK: Chart

struct Chart {

    let columns: [Column]

    struct Column {
        let groups: [Group]
    }

    struct Group {
        let emotions: [Emotion]
    }

    struct Emotion {
        let title: String
        let description: String
    }

    var numberOfGroups: Int {
        return columns.reduce(0) { numberOfGroups, column in
            numberOfGroups + column.groups.count
        }
    }

    func group(atIndex index: Int) -> Group {
        let columnIndex = (index + columns.count) % columns.count
        let groupIndex = index / columns.count
        return columns[columnIndex].groups[groupIndex]
    }

}
