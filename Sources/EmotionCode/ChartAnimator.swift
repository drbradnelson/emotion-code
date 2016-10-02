import UIKit

protocol ChartAnimatable {
	var sourceView: UIView? { get }
	var view: UIView! { get }
}

final class ChartAnimator: NSObject, UIViewControllerAnimatedTransitioning {

	private let operation: UINavigationControllerOperation
	private let duration: TimeInterval = 0.4

	init(operation: UINavigationControllerOperation) {
		self.operation = operation
	}

	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return duration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let container = transitionContext.containerView
		container.backgroundColor = .white

		guard
			let toVC = transitionContext.viewController(forKey: .to),
			let fromVC = transitionContext.viewController(forKey: .from) else { return }

		container.addSubview(toVC.view)
		container.addSubview(fromVC.view)
		toVC.view.alpha = 0

		let animations = {
			toVC.view.alpha = 1
			fromVC.view.alpha = 0
		}

		UIView.animate(withDuration: duration, animations: animations) { _ in
			fromVC.view.removeFromSuperview()
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		}
	}
}
