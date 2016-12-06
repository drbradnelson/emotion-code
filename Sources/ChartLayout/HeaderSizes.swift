public protocol HeaderSizes {

    var columnHeaderSizes: Size { get }
    var rowHeaderSizes: Size { get }

}

public extension HeaderSizes where Self: DefaultHeaderSizes {

    var columnHeaderSizes: Size {
        return Size(width: itemWidth, height: Self.headerSize.height)
    }

    var rowHeaderSizes: Size {
        return Size(width: Self.headerSize.width, height: maximumSectionHeights)
    }

    private static var headerSize: Size {
        return Size(width: 30, height: 30)
    }

}

public typealias DefaultHeaderSizes = HeaderSizes
    & ItemSizes
    & SectionHeights
