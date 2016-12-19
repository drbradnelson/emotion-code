public protocol HeaderSizeCalculator {

    var itemWidth: Float { get }
    var maximumSectionHeight: Float { get }

}

public extension HeaderSizeCalculator {

    var columnHeaderSize: Size {
        return Size(width: itemWidth, height: Self.headerSize.height)
    }

    var rowHeaderSize: Size {
        return Size(width: Self.headerSize.width, height: maximumSectionHeight)
    }

}

extension HeaderSizeCalculator {

    static var headerSize: Size {
        return Size(width: 30, height: 30)
    }

}
