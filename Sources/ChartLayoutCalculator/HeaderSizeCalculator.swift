public protocol HeaderSizeCalculator {

    var columnHeaderSize: Size { get }
    var rowHeaderSize: Size { get }

}

public extension HeaderSizeCalculator where Self: DefaultHeaderSizeCalculator {

    var columnHeaderSize: Size {
        return Size(width: itemWidth, height: Self.headerSize.height)
    }

    var rowHeaderSize: Size {
        return Size(width: Self.headerSize.width, height: maximumSectionHeight)
    }

    private static var headerSize: Size {
        return Size(width: 30, height: 30)
    }

}

public typealias DefaultHeaderSizeCalculator = HeaderSizeCalculator
    & ItemSizeCalculator
    & SectionHeightCalculator
