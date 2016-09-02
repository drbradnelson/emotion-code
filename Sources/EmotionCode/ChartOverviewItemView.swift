import Foundation
import UIKit

final class ChartOverviewItemView: UIView {

    private (set) var titleLabel: UILabel

    override init(frame: CGRect) {
        self.titleLabel = UILabel.init()
        super.init(frame: frame)

        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        self.titleLabel = UILabel.init()
        super.init(coder: aDecoder)

        self.setup()
    }
}

// MARK: View with title

extension ChartOverviewItemView : ViewWithTitle {}

// MARK: Setup

private extension ChartOverviewItemView {

    func setup() {
        self.addSubview(self.titleLabel)
        self.titleLabel.textAlignment = .Center
    }
}

// MARK: Layout calculation

extension ChartOverviewItemView {

    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.bounds
    }
}
