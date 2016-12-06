public protocol ContentPaddingProvider {

    var contentPadding: Float { get }

}

public extension ContentPaddingProvider {

    var contentPadding: Float {
        return 10
    }

}
