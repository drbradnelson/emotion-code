import UIKit

// MARK: Main

final class ChartRowDetailsViewController: UIViewController {

    @IBOutlet weak var chartRowTitleLabel: UILabel!
    @IBOutlet weak var rowDetailsView: UICollectionView!

    var chartRowPosition: ChartRowPosition?
    var interactionInProgress = false
    var runningTrans: UIPercentDrivenInteractiveTransition?
    
    private var shouldCompleteTransition = false

    private let chart = ChartController().chart

    private var chartRow: ChartRow?

}

// MARK: View lifecycle callbacks

extension ChartRowDetailsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareData()
        self.prepareUI()
        
        let gr = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(panGR(_:)))
        gr.edges = UIRectEdge.Left
        self.view.addGestureRecognizer(gr)
    }
    
    func panGR(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translationInView(gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
            
            
        case .Began:
            interactionInProgress = true
//            viewController.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController!.popViewControllerAnimated(true)
        case .Changed:
            shouldCompleteTransition = progress > 0.5
            self.runningTrans?.updateInteractiveTransition(progress)
            
            
        case .Cancelled:
            interactionInProgress = false
            self.runningTrans?.cancelInteractiveTransition()
            
            
        case .Ended:
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                self.runningTrans?.cancelInteractiveTransition()
                
            } else {
                self.runningTrans?.finishInteractiveTransition()
                
            }
            
            self.runningTrans = nil
            
        default:
            print("Unsupported")
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.rowDetailsView.reloadData()
        
        self.navigationController!.delegate = self
    }
}

// MARK: UINavigationController delegate

extension ChartRowDetailsViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        var transition: UIViewControllerAnimatedTransitioning? = nil
        if fromVC is ChartRowDetailsViewController && toVC is ChartOverviewViewController {
            transition = ChartOverviewToRowDetailsTransition.init(direction: .Backward)
        }
        
    }
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if interactionInProgress {
            self.runningTrans = UIPercentDrivenInteractiveTransition.init()
            return self.runningTrans
        } else {
            return nil
        }
        
        
    }
}

// MARK: Setup

private extension ChartRowDetailsViewController {

    func prepareData() {
        chartRow = chart.row(forPosition: chartRowPosition!)
    }

    func prepareUI() {

        chartRowTitleLabel.text = "Column \(chartRowPosition!.columnIndex) - Row \(chartRowPosition!.rowIndex)"

        rowDetailsView.delegate = self
        rowDetailsView.dataSource = self

        rowDetailsView.registerClass(CollectionViewCellWithTitle.self, forCellWithReuseIdentifier: ChartRowDetailsViewController.kRowDetailsCellIdentifier)
    }

}

// MARK: UICollectionViewDataSource methods

extension ChartRowDetailsViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chartRow!.items.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(ChartRowDetailsViewController.kRowDetailsCellIdentifier, forIndexPath: indexPath) as! CollectionViewCellWithTitle

        let item = chartRow!.items[indexPath.item]
        cell.title = item.title
        cell.backgroundColor = UIColor.lightGrayColor()

        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout methods

extension ChartRowDetailsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

        let horizontalInsets = ChartRowDetailsViewController.sectionInsets.left + ChartRowDetailsViewController.sectionInsets.right
        let availableSpace = collectionView.bounds.width - horizontalInsets

        let size = CGSize.init(width: availableSpace, height: ChartRowDetailsViewController.itemHeight)
        return size
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return ChartRowDetailsViewController.sectionInsets
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex  section: Int) -> CGFloat {
        return ChartRowDetailsViewController.spacingBetweenItems
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }

}

// MARK: Constants

private extension ChartRowDetailsViewController {

    static let kRowDetailsCellIdentifier = "RowDetailsCell"

    static let sectionInsets = UIEdgeInsets.init(top: 5, left: 10, bottom: 5, right: 10)
    static let spacingBetweenItems: CGFloat = 5
    static let itemHeight: CGFloat = 50

}
