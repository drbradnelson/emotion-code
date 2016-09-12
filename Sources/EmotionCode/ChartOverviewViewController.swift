import UIKit

// MARK: Main

final class ChartOverviewViewController: UIViewController {

    @IBOutlet weak var chartView: UICollectionView!
    private var chartOverviewLayout: ChartOverviewCollectionLayout!

    private let chart = ChartController().chart

    private var chartAdapter: ChartOverviewCollectionLayoutDataAdapter!

}

// MARK: View lifecycle callbacks

extension ChartOverviewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
        prepareUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        chartView.reloadData()
    }

}

// MARK: Preparation

private extension ChartOverviewViewController {

    func prepareData() {
        chartAdapter = ChartOverviewSimpleAdapter(chart: chart)
    }

    func prepareUI() {
        chartView.delegate = self
        chartView.dataSource = self

        chartOverviewLayout = ChartOverviewCollectionLayout()
        chartOverviewLayout.adapter = chartAdapter
        chartOverviewLayout.delegate = self

        chartView.setCollectionViewLayout(chartOverviewLayout, animated: false)

        chartView.registerClass(CollectionViewReusableViewWithTitle.self, forSupplementaryViewOfKind: ChartOverviewCollectionLayout.columnHeaderElementIdentifier, withReuseIdentifier: ChartOverviewCollectionLayout.columnHeaderElementIdentifier)
        chartView.registerClass(CollectionViewReusableViewWithTitle.self, forSupplementaryViewOfKind: ChartOverviewCollectionLayout.cowCounterElementIdentifier, withReuseIdentifier: ChartOverviewCollectionLayout.cowCounterElementIdentifier)

        chartView.registerClass(ChartOverviewRowCell.self, forCellWithReuseIdentifier: ChartOverviewCollectionLayout.rowElementIdentifier)
        ChartOverviewAccessibilityController.setupAccessibility(forChartOverviewView: chartView)
    }

}

// MARK: Collection view delegate

extension ChartOverviewViewController : UICollectionViewDelegate {}

// MARK: Collection view data source

extension ChartOverviewViewController : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartOverviewLayout.adapter.numberOfItems(inSection: section)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartOverviewCollectionLayout.rowElementIdentifier, forIndexPath: indexPath) as! ChartOverviewRowCell

        let rowPosition = chartAdapter.rowPosition(forIndexPath: indexPath)
        let row = chart.row(forPosition: rowPosition)
        let items = row.items

        cell.update(withItems: items)
        cell.update(itemBackgroundColor: UIColor.lightGrayColor())

        ChartOverviewAccessibilityController.setupAccessibility(forRowCell: cell, forRow: row, atRowPosition: rowPosition)

        return cell
    }


    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return chartOverviewLayout.adapter.numberOfSections()
    }


    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let identifier = kind
        var view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath) as! CollectionViewReusableViewWithTitle

        if kind == ChartOverviewCollectionLayout.columnHeaderElementIdentifier {
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

// MARK: Chart overview collection layout delegate

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
        return ChartOverviewRowCellLayout.height(forItems: chart.columns.enumerate().reduce(0, combine: { (maxItems, column) -> Int in
            let rowItemsNumber = chartAdapter.numberOfItems(forColumnIndex: column.index, forRowIndex: row)
            if rowItemsNumber > maxItems {
                return rowItemsNumber
            } else {
                return maxItems
            }
        }))
    }

    func insetsForContent(inCollectionView collectionView: UICollectionView, layout: ChartOverviewCollectionLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

}
