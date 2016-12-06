public typealias ChartData = Any
    & NumberOfSections
    & NumberOfItemsInSection

public protocol NumberOfSections {
    var numberOfSections: Int { get }
}

public protocol NumberOfItemsInSection {
    func numberOfItems(inSection section: Int) -> Int
}
