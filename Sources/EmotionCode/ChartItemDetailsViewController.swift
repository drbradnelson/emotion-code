import UIKit

// MARK: Main

class ChartItemDetailsViewController: UIViewController {

    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var itemDetailsView: UIView!

    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var detailsLabel: UILabel!

    var itemPosition: ChartItemPosition!

    private let chart = ChartController().chart

    private var transitionController: ChartItemDetailsTransitionController!

}


extension ChartItemDetailsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareUI()
        self.prepareData()
    }

    private func prepareUI() {
        let chartItem = self.chart.item(forPosition: self.itemPosition)

        self.nameLabel.text = chartItem.title
        self.detailsLabel.text = chartItem.description
    }

    private func prepareData() {
        self.transitionController = ChartItemDetailsTransitionController(chartItemDetailsViewController: self)
    }

}
