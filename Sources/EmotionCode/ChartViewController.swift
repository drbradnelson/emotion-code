import UIKit

final class ChartViewController: UICollectionViewController {

    private let chart = ChartController().chart

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.kindColumnHeader, withReuseIdentifier: ChartHeaderView.kindColumnHeader)
        collectionView?.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.kindRowHeader, withReuseIdentifier: ChartHeaderView.kindRowHeader)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.isScrollEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        collectionView?.isScrollEnabled = false
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
        case ChartHeaderView.kindColumnHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath) as! ChartHeaderView
            let alphabet = ["A", "B"]
            let column = (indexPath.section + ChartLayout.numberOfColumns) % ChartLayout.numberOfColumns
            view.configure(title: alphabet[column])
            return view
        case ChartHeaderView.kindRowHeader:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath) as! ChartHeaderView
            let index = (indexPath.section + ChartLayout.numberOfColumns) / ChartLayout.numberOfColumns
            view.configure(title: "\(index)")
            return view
        default:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)
        }
    }

    // MARK: Storyboard segue

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return collectionView?.collectionViewLayout is ChartLayout
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ChartColumnViewController {
            prepare(for: destination)
        }
    }

    private func prepare(for destination: ChartColumnViewController) {
        guard let section = collectionView?.indexPathForSelectedItem?.section else {
            preconditionFailure()
        }
        destination.setTitle(forSection: section)
        destination.group = chart.group(atIndex: section)
    }

}
