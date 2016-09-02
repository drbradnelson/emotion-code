import Foundation
import UIKit

protocol ViewWithTitle {
    var titleLabel: UILabel {get}
}

extension ViewWithTitle {

    var title: String? {
        get {
            return self.titleLabel.text
        }
        set (newTitle) {
            self.titleLabel.text = newTitle!
        }
    }

    var font: UIFont {
        get {
            return self.titleLabel.font
        }
        set (newFont) {
            self.titleLabel.font = font
        }
    }

    var textColor: UIColor {
        get {
            return self.titleLabel.textColor
        }
        set (newFont) {
            self.titleLabel.textColor = textColor
        }
    }

    var textAlighnment: NSTextAlignment {
        get {
            return self.titleLabel.textAlignment
        }
        set (newTextAlignment) {
            self.titleLabel.textAlignment = newTextAlignment
        }
    }
}
