import Foundation

extension Dictionary {

    mutating func mergeWith(dictionary: Dictionary) {
        dictionary.forEach { self.updateValue($1, forKey: $0) }
    }

}
