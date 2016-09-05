import UIKit

final class ChartOverviewViewController: UIViewController {
    @IBOutlet weak var chartView: UICollectionView!
    private var chartOverviewLayout: ChartOverviewCollectionLayout!

    private let chart = { () -> Chart in
        return ChartController().chart
    }()

    private (set) var chartAdapter: ChartOverviewCollectionLayoutDataAdapter!
    private var selectedRowPosition: ChartRowPosition?

    private let transitionController = ChartOverviewTransitionController()
}

// MARK: View lifecycle callbacks
extension ChartOverviewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareData()
        prepareUI()
    }

    private func prepareData() {
        chartAdapter = ChartOverviewSimpleAdapter.init(chart: chart)
    }

    private func prepareUI() {
        chartView.delegate = self
        chartView.dataSource = self

        chartOverviewLayout = ChartOverviewCollectionLayout.init()
        chartOverviewLayout.adapter = chartAdapter
        chartOverviewLayout.delegate = self

        chartView.setCollectionViewLayout(chartOverviewLayout, animated: false)

        chartView.registerClass(CollectionViewReusableViewWithTitle.self, forSupplementaryViewOfKind: ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier, withReuseIdentifier: ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier)
        chartView.registerClass(CollectionViewReusableViewWithTitle.self, forSupplementaryViewOfKind: ChartOverviewCollectionLayout.kRowCounterElementIdentifier, withReuseIdentifier: ChartOverviewCollectionLayout.kRowCounterElementIdentifier)

        chartView.registerClass(ChartOverviewRowCell.self, forCellWithReuseIdentifier: ChartOverviewCollectionLayout.kRowElementIdentifier)
        ChartOverviewAccessibilityController.setupAccessibilit(forChartOverviewView: chartView)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        chartView.reloadData()
    }
}

// MARK: UICollectionViewDelegate

extension ChartOverviewViewController : UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedRowPosition = chartAdapter.rowPosition(forIndexPath: indexPath)
        self.transitionController.goToRowDetails(self, forRowPosition: selectedRowPosition)
    }
}

extension ChartOverviewViewController {
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.transitionController.finishTransition(forSegue: segue)
    }
}

// MARK: UICollectionViewDataSource

extension ChartOverviewViewController : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartOverviewLayout.adapter.numberOfItems(inSection: section)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartOverviewCollectionLayout.kRowElementIdentifier, forIndexPath: indexPath) as! ChartOverviewRowCell

        let rowPosition = chartAdapter.rowPosition(forIndexPath: indexPath)
        let row = chart.row(forPosition: rowPosition)
        let items = row.items

        cell.update(withItems: items)
        cell.update(itemBackgroundColor: UIColor.lightGrayColor())

        ChartOverviewAccessibilityController.setupAccessibility(forRowCell: cell, forRow: row, atRowPosition: rowPosition)

        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int { return chartOverviewLayout.adapter.numberOfSections() }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        let identifier = kind
        var view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath) as! CollectionViewReusableViewWithTitle

        if kind == ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier {
            let columnIndex = chartAdapter.columnIndex(forIndexPath: indexPath)
            view.title = "\(columnIndex)"
            ChartOverviewAccessibilityController.setupAccessibility(forColumnHeader: view, forColumn: chart.columns[columnIndex], atIndex: columnIndex)
        } else {
            let rowIndex = chartAdapter.rowIndex(forIndexPath: indexPath)
            view.title = "\(rowIndex)"
            ChartOverviewAccessibilityController.setupAccessibility(forRowCounterView: view, atRowIndex: rowIndex)
        }

        return view
    }
}

// MARK: ChartOverviewCollectionLayoutDelegate

extension ChartOverviewViewController : ChartOverviewCollectionLayoutDelegate {

    func widthForRowCounterElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat {
        return 40
    }

    func heightForColumnHeaderElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat {
        return 40
    }

    func heightForItemElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat {
        return 20
    }

    func spacingBetweenColumns(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat {
        return 30
    }

    func spacingBetweenRows(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat {
        return 15
    }

    func spacingBetweenItems(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> CGFloat {
        return 5
    }

    func heightForRowElement(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout, forRow row: Int) -> CGFloat {

        var maxItems = 0
        for columnIndex in 0 ..< chartAdapter.numberOfColumns() {
            let rowItemsNumber = chartAdapter.numberOfItems(forColumnIndex: columnIndex, forRowIndex: row)
            if rowItemsNumber > maxItems {
                maxItems = rowItemsNumber
            }
        }

        let height = ChartOverviewRowCellLayout.height(forItems: maxItems)
        return height
    }

    func insetsForContent(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 10)
    }
}
