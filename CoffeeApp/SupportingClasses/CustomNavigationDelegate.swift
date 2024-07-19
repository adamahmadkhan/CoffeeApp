import UIKit

class CustomSpreadTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting: Bool = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5 // Adjust the duration of the transition
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to),
              let toView = toVC.view,
              let fromView = fromVC.view
        else {
            transitionContext.completeTransition(false)
            return
        }

        let containerView = transitionContext.containerView
        let screenWidth = containerView.frame.width
        let screenHeight = containerView.frame.height

        if isPresenting {
            // Push transition: Spread out
            containerView.addSubview(toView)

            // Initial state for toView
            toView.frame = CGRect(x: screenWidth / 2, y: screenHeight / 2, width: 0, height: 0)
            toView.layer.cornerRadius = 20
            toView.layer.masksToBounds = true

            // Perform animation
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                // Scale up and fade in toView
                toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })

        } else {
            // Pop transition: Spread in
            containerView.insertSubview(toView, belowSubview: fromView)

            // Initial state for toView (which is fromView in pop transition)
            toView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)

            // Perform animation
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                // Scale down and fade out fromView
                fromView.frame = CGRect(x: screenWidth / 2, y: screenHeight / 2, width: 0, height: 0)
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
