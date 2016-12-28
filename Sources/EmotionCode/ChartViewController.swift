import UIKit

final class ChartViewController: UICollectionViewController {

    private let chart = ChartController().chart

    private let screenIsSmall: Bool = {
        let screenSize = UIScreen.main.bounds.size
        let iphone6ScreenHeight: CGFloat = 667
        return screenSize.height < iphone6ScreenHeight
    }()

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.columnKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
        collectionView!.register(ChartHeaderView.self, forSupplementaryViewOfKind: ChartHeaderView.rowKind, withReuseIdentifier: ChartHeaderView.preferredReuseIdentifier)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.isScrollEnabled = screenIsSmall
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        collectionView!.isScrollEnabled = false
    }

    // MARK: Collection view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return chart.numberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chart.section(atIndex: section).emotions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.preferredReuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        let chartSection = chart.section(atIndex: indexPath.section)
        let emotion = chartSection.emotions[indexPath.item]
        cell.configure(with: emotion)
        cell.setBackgroundColor(for: indexPath)
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
        performSegue(withIdentifier: "ShowSection", sender: self)
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ChartSectionViewController {
            prepare(for: destination)
        }
    }

    private func prepare(for destination: ChartSectionViewController) {
        let section = collectionView!.indexPathForSelectedItem!.section
        destination.setTitle(forSection: section)
        destination.section = chart.section(atIndex: section)
    }

}

extension ChartViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutModule.Mode {
        return .all
    }

}
