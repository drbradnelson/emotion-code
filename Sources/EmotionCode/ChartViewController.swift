import UIKit
import ChartLayoutCalculator

final class ChartViewController: UICollectionViewController {

    private let chart = ChartController().chart

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.columnKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.rowKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.isScrollEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        collectionView!.isScrollEnabled = false
    }

    // MARK: Collection view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chart.numberOfGroups
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chart.group(atIndex: section).emotions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.preferredReuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        let chartGroup = chart.group(atIndex: indexPath.section)
        let emotion = chartGroup.emotions[indexPath.item]
        cell.configure(with: emotion)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
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

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowGroup", sender: self)
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ChartGroupViewController {
            prepare(for: destination)
        }
    }

    private func prepare(for destination: ChartGroupViewController) {
        guard let section = collectionView?.indexPathForSelectedItem?.section else {
            preconditionFailure()
        }
        destination.setTitle(forSection: section)
        destination.group = chart.group(atIndex: section)
    }

}

extension ChartViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutMode {
        return .all
    }

}
