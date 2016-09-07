//
//  ChartRowDetialsViewController.swift
//  EmotionCode
//
//  Created by Andre Lami on 31/08/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

// MARK: Main

class ChartRowDetailsViewController: UIViewController {

    @IBOutlet weak var chartRowTitleLabel: UILabel!
    @IBOutlet weak var rowDetailsView: UICollectionView!

    private var transitionController: ChartRowDetailsTransitionController!
    private let chart = ChartController().chart
    private var chartRow: ChartRow?

    var chartRowPosition: ChartRowPosition!

    private var transitionToItemDetailsController: ChartRowToItemTransitionController!
    private (set) var chartAdapter: ChartOverviewCollectionLayoutDataAdapter!
}

// MARK: View lifecycle callbacks

extension ChartRowDetailsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareData()
        self.prepareUI()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.rowDetailsView.reloadData()
    }

}

// MARK: Setup

extension ChartRowDetailsViewController {

    private func prepareData() {
        self.chartAdapter = ChartOverviewSimpleAdapter(chart: chart)
        self.chartRow = self.chart.row(forPosition: self.chartRowPosition!)
        self.transitionController = ChartRowDetailsTransitionController(chartRowDetailsViewController: self)
        self.transitionToItemDetailsController = ChartRowToItemTransitionController()
    }

    private func prepareUI() {

        self.chartRowTitleLabel.text = "Column \(self.chartRowPosition!.columnIndex) - Row \(self.chartRowPosition!.rowIndex)"

        self.rowDetailsView.delegate = self
        self.rowDetailsView.dataSource = self

        self.rowDetailsView.registerClass(CollectionViewCellWithTitle.self, forCellWithReuseIdentifier: ChartRowDetailsViewController.rowDetailsCellIdentifier)

        ChartRowDetailsAccessibilityController.setupAccessibilit(forChartOverviewView: rowDetailsView)
    }

}


extension ChartRowDetailsViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.transitionToItemDetailsController.finishTransition(forSegue: segue)
    }

}

// MARK: UICollectionViewDelegate methods

extension ChartRowDetailsViewController {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)

        let itemPosition = ChartItemPosition.init(column: self.chartRowPosition.columnIndex, row: self.chartRowPosition.rowIndex, item: indexPath.item)
        self.transitionToItemDetailsController.goToRowDetails(self, forItemPosition: itemPosition)
    }

}

// MARK: UICollectionViewDataSource methods

extension ChartRowDetailsViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chartRow!.items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartRowDetailsViewController.rowDetailsCellIdentifier, forIndexPath: indexPath) as! CollectionViewCellWithTitle

        let item = self.chartRow!.items[indexPath.item]
        cell.title = item.title
        cell.backgroundColor = UIColor.lightGrayColor()

        ChartRowDetailsAccessibilityController.setupAccessibility(forRowCounterView: cell, atRowIndex: indexPath.row)

        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout methods

extension ChartRowDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let horizontalInsets = ChartRowDetailsViewController.sectionInsets.left + ChartRowDetailsViewController.sectionInsets.right
        let availableSpace = collectionView.bounds.width - horizontalInsets

        let size = CGSize(width: availableSpace, height: ChartRowDetailsViewController.itemHeight)
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

    static let rowDetailsCellIdentifier = "RowDetailsCell"

    static let sectionInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    static let spacingBetweenItems: CGFloat = 5
    static let itemHeight: CGFloat = 50

    static let itemBackgroundColor = UIColor(red: 216.0/255.0, green: 216.0/255.0, blue: 216.0/255.0, alpha: 1.0)

}
