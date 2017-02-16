import UIKit

final class ChartViewControllerDataSource: NSObject, UICollectionViewDataSource {

    let chart = ChartController().chart

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chart.numberOfSections
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chart.section(atIndex: section).emotions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.preferredReuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        let chartSection = chart.section(atIndex: indexPath.section)
        let emotion = chartSection.emotions[indexPath.item]
        cell.configure(with: emotion)
        cell.setBackgroundColor(for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case ChartHeaderView.columnKind:
            let columnHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier, for: indexPath) as! ChartHeaderView
            let column = (indexPath.section + ChartLayout.numberOfColumns) % ChartLayout.numberOfColumns
            let columnName = String.alphabet[column]
            columnHeader.configure(title: columnName)
            return columnHeader
        case ChartHeaderView.rowKind:
            let rowHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier, for: indexPath) as! ChartHeaderView
            let row = (indexPath.section + ChartLayout.numberOfColumns) / ChartLayout.numberOfColumns
            rowHeader.configure(title: String(row))
            return rowHeader
        default:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "", for: indexPath)
        }
    }

}
