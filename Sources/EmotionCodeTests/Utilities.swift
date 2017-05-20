@testable import EmotionCode

extension Size: Equatable {
    public static func == (lhs: Size, rhs: Size) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

extension Point {
    // swiftlint:disable:next identifier_name
    init(x: Int = 0, y: Int = 0) {
        self.x = x
        self.y = y
    }
}
