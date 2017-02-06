import UIKit
import Elm

final class ChartSectionViewController: UICollectionViewController {

    var chart: Chart!

    private var chartLayout: ChartLayout {
        return collectionViewLayout as! ChartLayout
    }

    // MARK: Title

    func setTitle(forSection section: Int) {
        let column = (section + ChartLayout.numberOfColumns) % ChartLayout.numberOfColumns
        let row = section / ChartLayout.numberOfColumns + 1
        let columnName = String.alphabet[column]
        let localizedFormat = NSLocalizedString("Column %@ - Row %i", comment: "")
        navigationItem.title = String.localizedStringWithFormat(localizedFormat, columnName, row)
    }

    // MARK: View lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutCellsAlongsideTransition()
        layoutSupplementaryViewsAlongsideTransition(withKinds: [ChartHeaderView.rowKind, ChartHeaderView.columnKind])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chartLayout.program.setDelegate(self)
        collectionView!.isScrollEnabled = chartLayout.program.view.isScrollEnabled
        collectionView!.bounces = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        layoutCellsAlongsideTransition()
        layoutSupplementaryViewsAlongsideTransition(withKinds: [ChartHeaderView.rowKind, ChartHeaderView.columnKind])
    }

    // MARK: Collection view delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowEmotion", sender: self)
    }

    // MARK: Scroll view delegate

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        chartLayout.program.dispatch(.userDidScroll(withVelocity: .init(velocity)))
        targetContentOffset.pointee = chartLayout.program.view.proposedContentOffset!.cgPoint
    }

    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(chartLayout.program.view.proposedContentOffset!.cgPoint, animated: true)
    }

    // MARK: Storyboard segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let destination = segue.destination as? ChartEmotionViewController {
            prepare(for: destination)
        }
    }

    private func prepare(for destination: ChartEmotionViewController) {
        let indexPath = collectionView!.indexPathForSelectedItem!
        let emotion = chart.section(atIndex: indexPath.section).emotions[indexPath.item]
        destination.setTitle(for: emotion)
    }

}

extension ChartSectionViewController: ChartPresenter {

    func chartLayoutMode(with collectionView: UICollectionView) -> ChartLayoutModule.Mode {
        let selectedSection = collectionView.indexPathForSelectedItem!.section
        return .section(selectedSection)
    }

}

extension ChartSectionViewController: Elm.Delegate {

    typealias Module = ChartLayoutModule

    func program(_ program: Program<Module>, didEmit command: Module.Command) {
        guard case let .setSection(section) = command else { return }
        setTitle(forSection: section)
    }

    func program(_ program: Program<Module>, didUpdate view: Module.View) {}

}
