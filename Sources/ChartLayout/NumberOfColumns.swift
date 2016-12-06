public protocol NumberOfColumns {

    static var numberOfColumns: Int { get }

}

public extension NumberOfSections {

    static var numberOfColumns: Int {
        return 2
    }

}
