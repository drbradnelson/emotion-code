import Foundation

extension IndexPath {

    var section: Int {
        return self[0]
    }

    var item: Int {
        return self[1]
    }

}
