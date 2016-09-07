import UIKit

protocol ViewWithTitle {
    var titleLabel: UILabel {get}
}

extension ViewWithTitle {

    var title: String? {
        get {
            return titleLabel.text
        }
        set (newTitle) {
            titleLabel.text = newTitle!
        }
    }

    var font: UIFont {
        get {
            return titleLabel.font
        }
        set (newFont) {
            titleLabel.font = font
        }
    }

    var textColor: UIColor {
        get {
            return titleLabel.textColor
        }
        set (newFont) {
            titleLabel.textColor = textColor
        }
    }

    var textAlighnment: NSTextAlignment {
        get {
            return titleLabel.textAlignment
        }
        set (newTextAlignment) {
            titleLabel.textAlignment = newTextAlignment
        }
    }
}
