//
//  ChartOverviewLayoutParams.swift
//  EmotionCode
//
//  Created by Andre Lami on 31/08/16.
//  Copyright © 2016 DiscoverHealing.com. All rights reserved.
//

import Foundation
import UIKit

protocol ChartOverviewLayoutParams {
    var widthForRowCounterElement: CGFloat {get}
    var heightForColumnHeaderElement: CGFloat {get}
    var spacingBetweenColumns: CGFloat {get}
    var spacingBetweenRows: CGFloat {get}
    var availableWidth: CGFloat {get}

    func heightForRowElement(forRow row: Int) -> CGFloat
}

extension ChartOverviewCollectionLayout: ChartOverviewLayoutParams {
    var widthForRowCounterElement: CGFloat {
        get {
            return self.delegate.widthForRowCounterElement(inCollectionView: self.collectionView!, layout: self)
        }
    }

    var heightForColumnHeaderElement: CGFloat {
        get {
            return self.delegate.heightForColumnHeaderElement(inCollectionView: self.collectionView!, layout: self)
        }
    }

    var spacingBetweenColumns: CGFloat {
        get {
            return self.delegate.spacingBetweenColumns(inCollectionView: self.collectionView!, layout: self)
        }
    }

    var spacingBetweenRows: CGFloat {
        get {
            return self.delegate.spacingBetweenRows(inCollectionView: self.collectionView!, layout: self)
        }
    }

    var availableWidth: CGFloat {
        get {
            return CGRectGetWidth(self.collectionView!.bounds)
        }
    }

    func heightForRowElement(forRow row: Int) -> CGFloat {
        return self.delegate.heightForRowElement(inCollectionView: self.collectionView!, layout: self, forRow: row)
    }

    var layoutParams: ChartOverviewLayoutParams {
        get {
            return self
        }
    }
}
