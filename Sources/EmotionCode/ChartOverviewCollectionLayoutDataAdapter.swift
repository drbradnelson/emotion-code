import Foundation
import UIKit

protocol ChartOverviewCollectionLayoutDataAdapter {
    func numberOfColumns() -> Int
    func numberOfRows(forColumnIndex column: Int) -> Int
    func numberOfItems(forColumnIndex column: Int, forRowIndex row: Int) -> Int

    func numberOfSections() -> Int
    func numberOfItems(inSection section: Int) -> Int

    func indexPath(forColumnIndex columnIndex: Int) -> NSIndexPath
    func columnIndex(forIndexPath indexPath: NSIndexPath) -> Int

    func indexPath(forRowIndex rowIndex: Int) -> NSIndexPath
    func rowIndex(forIndexPath indexPath: NSIndexPath) -> Int

    func indexPath(forRowPosition rowPosition: ChartRowPosition) -> NSIndexPath
    func rowPosition(forIndexPath indexPath: NSIndexPath) -> ChartRowPosition
}
