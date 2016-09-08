extension Dictionary {

    mutating func mergeWith(dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }

}
