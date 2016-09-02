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

    var chartRowPosition: ChartRowPosition?

    private let chart = { () -> Chart in
        return ChartController().chart
    }()

    private var chartRow: ChartRow?
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
        
        self.navigationController!.delegate = self
    }
}

// MARK: UINavigationController delegate

extension ChartRowDetailsViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var transition: UIViewControllerAnimatedTransitioning? = nil
        if fromVC is ChartRowDetailsViewController && toVC is ChartOverviewViewController {
            transition = ChartOverviewToRowDetailsTransition.init(direction: .Backward)
        }
        
        return transition
    }
}

// MARK: Setup

extension ChartRowDetailsViewController {
    private func prepareData() {
        self.chartRow = self.chart.row(forPosition: self.chartRowPosition!)
    }

    private func prepareUI() {

        self.chartRowTitleLabel.text = "Column \(self.chartRowPosition!.columnIndex) - Row \(self.chartRowPosition!.rowIndex)"

        self.rowDetailsView.delegate = self
        self.rowDetailsView.dataSource = self

        self.rowDetailsView.registerClass(CollectionViewCellWithTitle.self, forCellWithReuseIdentifier: ChartRowDetailsViewController.kRowDetailsCellIdentifier)
    }
}

// MARK: UICollectionViewDataSource methods

extension ChartRowDetailsViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chartRow!.items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartRowDetailsViewController.kRowDetailsCellIdentifier, forIndexPath: indexPath) as! CollectionViewCellWithTitle

        let item = self.chartRow!.items[indexPath.item]
        cell.title = item.title
        cell.backgroundColor = UIColor.lightGrayColor()

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
    static let itemHeight: CGFloat = 50
}
