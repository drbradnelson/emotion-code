struct Chart {

    let columns: [Column]

    struct Column {
        let sections: [Section]
    }

    struct Section {
        let emotions: [Emotion]
    }

    struct Emotion {
        let title: String
        let description: String
    }

    var numberOfSections: Int {
        return columns.reduce(0) { numberOfSections, column in
            numberOfSections + column.sections.count
        }
    }

    func section(atIndex index: Int) -> Section {
        let columnIndex = (index + columns.count) % columns.count
        let sectionIndex = index / columns.count
        return columns[columnIndex].sections[sectionIndex]
    }

}
