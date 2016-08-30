//
//  ChartOverviewCollectionLayoutDataAdapter.swift
//  EmotionCode
//
//  Created by Andre Lami on 30/08/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

protocol ChartOverviewCollectionLayoutDataAdapter {
    func numberOfColumns() -> Int
    func numberOfRows(forColumn column: Int) -> Int
    func numberOfItems(forColumn column: Int, forRow row: Int) -> Int
    func numberOfItems(inSection section: Int) -> Int
    func numberOfSections() -> Int

    func indexPath(forItemPosition itemPosition: ChartItemPosition) -> NSIndexPath
    func chartItemPosition(forIndexPath indexPath: NSIndexPath) -> ChartItemPosition

    func indexPath(forColumnPosition columnPosition: Int) -> NSIndexPath
    func columnPosition(forIndexPath indexPath: NSIndexPath) -> Int

    func indexPath(forRowPosition rowPosition: Int) -> NSIndexPath
    func rowPosition(forIndexPath indexPath: NSIndexPath) -> Int
}

extension ChartOverviewCollectionLayoutDataAdapter {
    func forEachItemPosition(enumerationBlock: (itemPosition: ChartItemPosition) -> ()) {
        for columnPosition in 0 ..< self.numberOfColumns() {
            for rowPosition in 0 ..< self.numberOfRows(forColumn: columnPosition) {
                for itemPosition in 0 ..< self.numberOfItems(forColumn: columnPosition, forRow: rowPosition) {
                    let chartItemPosition = ChartItemPosition.init(
                        column: columnPosition,
                        row: rowPosition,
                        item: itemPosition
                    )

                    enumerationBlock(itemPosition: chartItemPosition)
                }
            }
        }
    }
}