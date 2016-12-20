extension String {

    static var alphabet: [String] {
        return Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters).map { String($0) }
    }

}
