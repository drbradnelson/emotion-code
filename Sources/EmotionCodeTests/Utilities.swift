@testable import EmotionCode

typealias Module = ChartLayoutModule
typealias Mode = Module.Mode
typealias Message = Module.Message
typealias Model = Module.Model
typealias View = Module.View

extension Mode: Equatable {
    public static func ==(lhs: Mode, rhs: Mode) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

extension Model: Equatable {
    public static func ==(lhs: Model, rhs: Model) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

extension Size: Equatable {
    public static func ==(lhs: Size, rhs: Size) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

extension Point: Equatable {
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
