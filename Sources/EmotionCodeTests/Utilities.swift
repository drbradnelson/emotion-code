protocol StringEquatable: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool
}

extension StringEquatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
