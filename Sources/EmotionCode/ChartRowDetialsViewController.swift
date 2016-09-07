import UIKit

// MARK: Main

final class ChartRowDetailsViewController: UIViewController {

    @IBOutlet weak var chartRowTitleLabel: UILabel!
    @IBOutlet weak var rowDetailsView: UICollectionView!

    var chartRowPosition: ChartRowPosition?

    private let chart = ChartController().chart

    private var chartRow: ChartRow?

}

// MARK: View lifecycle callbacks

extension ChartRowDetailsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareData()
        prepareUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        rowDetailsView.reloadData()
    }

}

// MARK: Setup

private extension ChartRowDetailsViewController {

    func prepareData() {
        chartRow = chart.row(forPosition: chartRowPosition!)
    }

    func prepareUI() {

        chartRowTitleLabel.text = "Column \(chartRowPosition!.columnIndex) - Row \(chartRowPosition!.rowIndex)"

        rowDetailsView.delegate = self
        rowDetailsView.dataSource = self

        rowDetailsView.registerClass(CollectionViewCellWithTitle.self, forCellWithReuseIdentifier: ChartRowDetailsViewController.kRowDetailsCellIdentifier)
    }

}

// MARK: UICollectionViewDataSource methods

extension ChartRowDetailsViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartRow!.items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartRowDetailsViewController.kRowDetailsCellIdentifier, forIndexPath: indexPath) as! CollectionViewCellWithTitle

        let item = chartRow!.items[indexPath.item]
        cell.title = item.title
        cell.backgroundColor = UIColor.grayColor()

        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout methods

extension ChartRowDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let horizontalInsets = ChartRowDetailsViewController.sectionInsets.left + ChartRowDetailsViewController.sectionInsets.right
        let availableSpace = collectionView.bounds.width - horizontalInsets

        let size = CGSize.init(width: availableSpace, height: ChartRowDetailsViewController.itemHeight)
        return size
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return ChartRowDetailsViewController.sectionInsets
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex  section: Int) -> CGFloat {
        return ChartRowDetailsViewController.spacingBetweenItems
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

}

// MARK: Constants

private extension ChartRowDetailsViewController {

    static let kRowDetailsCellIdentifier = "RowDetailsCell"

    static let sectionInsets = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
    static let spacingBetweenItems: CGFloat = 5
    static let itemHeight: CGFloat = 40

}
