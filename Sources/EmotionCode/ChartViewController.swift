import UIKit

// MARK: Main

final class ChartViewController: UIViewController, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!

}

// MARK: View lifecycle

extension ChartViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let chartFlowLayout = ChartFlowLayout()
        collectionView.collectionViewLayout = chartFlowLayout
    }

}

// MARK: Collection view data source

extension ChartViewController {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ChartCell
        return cell
    }

}
