//
//  ChartOverviewViewController.swift
//  EmotionCode
//
//  Created by Andre Lami on 30/08/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

final class ChartOverviewViewController: UIViewController {
    @IBOutlet weak var chartView: UICollectionView!
    private var chartOverviewLayout: ChartOverviewCollectionLayout!

    private let chart = { () -> Chart in
        return ChartController().chart
    }()

    private var chartAdapter: ChartOverviewCollectionLayoutDataAdapter!
}

// MARK: View lifecycle callbacks
extension ChartOverviewViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareData()
        self.prepareUI()
    }

    private func prepareData() {
        self.chartAdapter = ChartOverviewSimpleAdapter.init(chart: self.chart)
    }

    private func prepareUI() {
        self.chartView.delegate = self
        self.chartView.dataSource = self

        self.chartOverviewLayout = ChartOverviewCollectionLayout.init()
        self.chartOverviewLayout.adapter = self.chartAdapter
        self.chartOverviewLayout.delegate = self

        self.chartView.setCollectionViewLayout(self.chartOverviewLayout, animated: false)

        self.chartView.registerClass(CollectionViewReusableViewWithTitle.self, forSupplementaryViewOfKind: ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier, withReuseIdentifier: ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier)
        self.chartView.registerClass(CollectionViewReusableViewWithTitle.self, forSupplementaryViewOfKind: ChartOverviewCollectionLayout.kRowCounterElementIdentifier, withReuseIdentifier: ChartOverviewCollectionLayout.kRowCounterElementIdentifier)

        self.chartView.registerClass(ChartOverviewRowCell.self, forCellWithReuseIdentifier: ChartOverviewCollectionLayout.kRowElementIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.chartView.reloadData()
    }
}

// MARK: UICollectionViewDelegate

extension ChartOverviewViewController : UICollectionViewDelegate {}

// MARK: UICollectionViewDataSource

extension ChartOverviewViewController : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chartOverviewLayout.adapter.numberOfItems(inSection: section)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartOverviewCollectionLayout.kRowElementIdentifier, forIndexPath: indexPath) as! ChartOverviewRowCell

        let rowPosition = self.chartAdapter.rowPosition(forIndexPath: indexPath)
        let row = self.chart.row(forPosition: rowPosition)
        let items = row.items

        cell.update(withItems: items)
        cell.update(itemBackgroundColor: UIColor.lightGrayColor())

        return cell
    }


    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.chartOverviewLayout.adapter.numberOfSections()
    }


    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

        let identifier = kind
        var view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath) as! CollectionViewReusableViewWithTitle

        if kind == ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier {
            let columnIndex = self.chartAdapter.columnIndex(forIndexPath: indexPath)
            view.title = "\(columnIndex)"
        } else {
            let rowIndex = self.chartAdapter.rowIndex(forIndexPath: indexPath)
            view.title = "\(rowIndex)"
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
        for columnIndex in 0 ..< self.chartAdapter.numberOfColumns() {
            let rowItemsNumber = self.chartAdapter.numberOfItems(forColumnIndex: columnIndex, forRowIndex: row)
            if rowItemsNumber > maxItems {
                maxItems = rowItemsNumber
            }
        }

        let height = ChartOverviewRowCellLayout.height(forItems: maxItems)
        return height
    }
}
