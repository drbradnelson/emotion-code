//
//  ChartOverviewViewController.swift
//  EmotionCode
//
//  Created by Andre Lami on 30/08/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

final class ChartOverviewViewController : UIViewController {
    @IBOutlet weak var chartView: UICollectionView!
    private var chartOverviewLayout: ChartOverviewCollectionLayout!

    private let chart = { () -> Chart in
        return ChartController().chart
    }()
    
   
}

extension ChartOverviewViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chartView.delegate = self
        self.chartView.dataSource = self
        
        let layout = ChartOverviewCollectionLayout()
        layout.delegate = self
        layout.adapter = ChartOverviewDataAdapter.init(chart: self.chart)
        
        self.chartOverviewLayout = layout
        
        self.chartView.setCollectionViewLayout(layout, animated: false)
        self.chartView.registerClass(ChartOverviewColumnHeaderView.self, forSupplementaryViewOfKind: ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier, withReuseIdentifier: ChartOverviewCollectionLayout.kColumnHeaderElementIdentifier)
        self.chartView.registerClass(ChartOverviewRowCounterView.self, forSupplementaryViewOfKind: ChartOverviewCollectionLayout.kRowCounterElementIdentifier, withReuseIdentifier: ChartOverviewCollectionLayout.kRowCounterElementIdentifier)
        
        self.chartView.registerClass(ChartOverviewItemCell.self, forCellWithReuseIdentifier: ChartOverviewCollectionLayout.kItemElementIdentifier)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.chartView.reloadData()
    }
}

// MARK: UICollectionViewDelegate

extension ChartOverviewViewController : UICollectionViewDelegate {


}

// MARK: UICollectionViewDataSource

extension ChartOverviewViewController : UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chartOverviewLayout.adapter.numberOfItems(inSection: section)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartOverviewCollectionLayout.kItemElementIdentifier, forIndexPath: indexPath)
        
        return cell
    }


    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.chartOverviewLayout.adapter.numberOfSections()
    }


    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: kind, forIndexPath: indexPath)
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

}