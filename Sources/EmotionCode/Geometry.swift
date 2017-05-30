struct Point {

    // swiftlint:disable:next identifier_name
    var x: Int

    // swiftlint:disable:next identifier_name
    var y: Int

    static let zero = Point(x: 0, y: 0)

    public static func - (lhs: Point, rhs: Point) -> Point {
        let x = lhs.x - rhs.x
        let y = lhs.y - rhs.y
        return Point(x: x, y: y)
    }

}

struct Size {

    var width: Int
    var height: Int

    static let zero = Size(width: 0, height: 0)

}

struct Rect {

    var origin: Point
    var size: Size

    var maxX: Int {
        return origin.x + size.width
    }

    var maxY: Int {
        return origin.y + size.height
    }

}
