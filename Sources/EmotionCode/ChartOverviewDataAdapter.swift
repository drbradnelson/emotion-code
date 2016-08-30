//
//  ChartOverviewDataAdapter.swift
//  EmotionCode
//
//  Created by Andre Lami on 30/08/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation

class ChartOverviewDataAdapter {
    
    private var chart: Chart
    init(chart: Chart) {
        self.chart = chart
    }
}

extension ChartOverviewDataAdapter : ChartOverviewCollectionLayoutDataAdapter {

    func numberOfColumns() -> Int {
        return chart.columns.count
    }
    
    func numberOfRows(forColumn column: Int) -> Int {
        return self.chart.columns[column].rows.count
    }
    
    func numberOfItems(forColumn column: Int, forRow row: Int) -> Int {
        return self.chart.columns[column].rows[row].items.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        let rowPosition = section
        var itemsCount = 0
        for columnPosition in 0 ..< self.numberOfColumns() {
            let rows = self.chart.columns[columnPosition].rows
            if rowPosition < rows.count  {
                itemsCount += rows[rowPosition].items.count
            }
        }
        
        return itemsCount
    }
    
    func numberOfSections() -> Int {
        var maxRowsCount = 0
        for columnPosition in 0 ..< self.numberOfColumns() {
            let rows = self.chart.columns[columnPosition].rows
            if maxRowsCount < rows.count {
                maxRowsCount = rows.count
            }
        }
        
        return maxRowsCount
    }
    
    func indexPath(forItemPosition itemPosition: ChartItemPosition) -> NSIndexPath {
        let section = itemPosition.rowPosition
        var itemsCounter = 0
        for columnPosition in 0 ..< itemPosition.columnPosition {
            let column = self.chart.columns[columnPosition]
            itemsCounter = column.rows[itemPosition.rowPosition].items.count
        }
        
        itemsCounter += itemPosition.itemPosition
        
        return NSIndexPath.init(forItem: itemsCounter, inSection: section)
    }
    
    func chartItemPosition(forIndexPath indexPath: NSIndexPath) -> ChartItemPosition {
        let rowPosition = indexPath.section
        var itemPositionCounter = indexPath.item
        
        var itemColumnPosition = 0
        let itemRowPosition = rowPosition
        var itemPosition = 0
        
        for columnPosition in 0 ..< self.numberOfColumns() {
            itemColumnPosition = columnPosition
            
            let items = self.chart.columns[columnPosition].rows[rowPosition].items
            if itemPositionCounter >= items.count  {
                itemPositionCounter -= items.count
            } else {
                itemPosition = itemPositionCounter
                break
            }
        }
        
        let chartItemPosition = ChartItemPosition.init(column: itemColumnPosition, row: itemRowPosition, item: itemPosition)
        return chartItemPosition
    }
    
    func indexPath(forColumnPosition columnPosition: Int) -> NSIndexPath {
        return NSIndexPath.init(forItem: 0, inSection: columnPosition)
    }
    
    func columnPosition(forIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.section
    }
    
    func indexPath(forRowPosition rowPosition: Int) -> NSIndexPath {
        return NSIndexPath.init(forItem: 0, inSection: rowPosition)
    }
    func rowPosition(forIndexPath indexPath: NSIndexPath) -> Int {
        return indexPath.section
    }
}