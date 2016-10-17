import UIKit

final class ChartViewController: UICollectionViewController, UINavigationControllerDelegate {

    private let columns = ChartController().chart.rows.reduce([]) { columns, row in
        columns + row.columns
    }

    var selectedIndexPath = IndexPath(item: 0, section: 0)

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }

    // MARK: Collection view data source

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return columns.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns[section].items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.reuseIdentifier, for: indexPath) as! ItemCollectionViewCell
        let title = columns[indexPath.section].items[indexPath.item].title
        cell.configure(title: title)
        return cell
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? ChartColumnViewController,
            let indexPath = collectionView?.indexPathsForSelectedItems?.first else { return }

        destination.useLayoutToLayoutNavigationTransitions = true
        destination.column = columns[indexPath.section]
    }

    // MARK: Navigation controller delegate

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ChartViewController {
            vc.collectionView?.dataSource = vc
            vc.collectionView?.scrollToItem(at: selectedIndexPath, at: .top, animated: false)
        } else if let vc = viewController as? ChartColumnViewController {
            vc.collectionView?.scrollToItem(at: selectedIndexPath, at: .top, animated: true)
            vc.collectionView?.delegate = vc
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? ChartViewController {
            vc.collectionView?.scrollToItem(at: selectedIndexPath, at: .top, animated: false)
        } else if let vc = viewController as? ChartColumnViewController {
            vc.collectionView?.dataSource = vc
        }
    }

}
