public typealias ChartDataProvider = Any
    & NumberOfSectionsProvider
    & NumberOfItemsInSectionProvider

public protocol NumberOfSectionsProvider {
    var numberOfSections: Int { get }
}

public protocol NumberOfItemsInSectionProvider {
    func numberOfItems(inSection section: Int) -> Int
}
