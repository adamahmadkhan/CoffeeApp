//
//  CustomNavigationTransition.swift
//  CoffeeApp
//
//  Created by Adam Khan on 7/19/24.
//

import Foundation
import UIKit

class CustomNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toController = transitionContext.viewController(forKey: .to)!.view, let fromController = transitionContext.viewController(forKey: .from)!.view else {
            transitionContext.completeTransition(false)
            return }

        let containerView = transitionContext.containerView
        if isPresenting {
            containerView.addSubview(toController)
            toController.frame = CGRect(x: containerView.frame.width / 2, y: containerView.frame.height / 2 , width: 0, height: 0)
            toController.layer.cornerRadius = 20
            toController.layer.masksToBounds = true
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toController.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
                //toController.superview?.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })

        } else {
            containerView.insertSubview(toController, belowSubview: fromController)
            toController.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromController.frame = CGRect(x: containerView.frame.width / 2, y: containerView.frame.height / 2, width: 0, height: 0)
                //toController.superview?.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
