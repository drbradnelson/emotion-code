import UIKit

final class ChartNavigationController: UINavigationController {

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer!.isEnabled = false
    }

}
