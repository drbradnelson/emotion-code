import Foundation

struct TransitionValueSelector {

    static func selectVal<ValueType>(forDirection direction: TransitionDirection, forwarVal: ValueType, backwardVal: ValueType) -> ValueType {
        if direction == TransitionDirection.Forward {
            return forwarVal
        } else {
            return backwardVal
        }
    }
}
