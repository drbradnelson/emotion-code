import Foundation

@testable import EmotionCode

extension ChartLayoutModule.Flags {

    init(
        mode: ChartLayoutModule.Mode = .all,
        itemsPerSection: [Int] = [],
        numberOfColumns: Int = 2,
        topContentInset: Int = 0
        ) {
        self.mode = mode
        self.itemsPerSection = itemsPerSection
        self.numberOfColumns = numberOfColumns
        self.topContentInset = topContentInset
    }

}

extension ChartLayoutModule.Model {
    init(
        flags: ChartLayoutModule.Flags = .init(),
        contentPadding: Int = 10,
        headerSize: Size = Size(width: 30, height: 30),
        sectionSpacing: Size = Size(width: 5, height: 5),
        itemHeight: Int = 30,
        itemSpacing: Int = 10,
        minViewHeightForCompactLayout: Int = 554,
        viewSize: Size = .zero
        ) {
        self.flags = flags
        self.contentPadding = contentPadding
        self.headerSize = headerSize
        self.sectionSpacing = sectionSpacing
        self.itemHeight = itemHeight
        self.itemSpacing = itemSpacing
        self.minViewHeightForCompactLayout = minViewHeightForCompactLayout
        self.viewSize = viewSize
    }
}

extension Size {
    init(width: Int = 0, height: Int = 0) {
        self.width = width
        self.height = height
    }
}

extension IndexPath {
    static let arbitrary = IndexPath(item: 10, section: 20)
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
