public protocol NumberOfColumnsProvider {

    static var numberOfColumns: Int { get }

}

public extension NumberOfSectionsProvider {

    static var numberOfColumns: Int {
        return 2
    }

}
