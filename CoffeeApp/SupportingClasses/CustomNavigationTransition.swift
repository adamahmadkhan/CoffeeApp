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
        return 2
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toController = transitionContext.viewController(forKey: .to)!.view, let fromController = transitionContext.viewController(forKey: .from)!.view else {
            transitionContext.completeTransition(false)
            return }

        let containerView = transitionContext.containerView
        if isPresenting {
            containerView.addSubview(toController)
            //toController.frame = CGRect(x: containerView.frame.width / 2, y: containerView.frame.height / 2 , width: 50, height: 50)
            //toController.transform = CGAffineTransform(rotationAngle: CGFloat(360 * Double.pi) / 360)
            toController.frame = CGRect(x: fromController.frame.width / 2, y: fromController.frame.height / 2 , width: 50 , height: 50)
            toController.layer.cornerRadius = containerView.frame.height / 2
            toController.layer.masksToBounds = true
            UIView.animate(withDuration: (transitionDuration(using: transitionContext)), animations: {
                toController.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
                //containerView.layer.cornerRadius = 0
                toController.layer.cornerRadius = 0
                //toController.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
                //toController.layer.cornerRadius = 0
                //toController.layer.cornerRadius = toController.frame.width / 2
//                UIView.animate(withDuration: 0.5) {
//                    toController.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi) / 360)
//                }
//                UIView.animate(withDuration: 0.5) {
//                    toController.transform = CGAffineTransform(rotationAngle: CGFloat(360 * Double.pi) / 360)
//                }
//                UIView.animate(withDuration: 0.5) {
//                    toController.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi) / 360)
//                }
//                UIView.animate(withDuration: 0.5) {
//                    toController.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi) / 360)
//                }
//                UIView.animate(withDuration: 0.5) {
//                    toController.transform = CGAffineTransform(rotationAngle: CGFloat(360 * Double.pi) / 360)
//                }
//                UIView.animate(withDuration: 0.5) {
//                    toController.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi) / 360)
//                }
                //toController.superview?.alpha = 1
            }, completion: { _ in
//                UIView.animate(withDuration: 0.3) {
//                    toController.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
//                    toController.layer.cornerRadius = 0
//                }
//                transitionContext.completeTransition(true)
            })

        } else {
            //fromController.transform = CGAffineTransform(rotationAngle: CGFloat(360 * Double.pi) / -360)
            fromController.layer.cornerRadius = 0
            containerView.insertSubview(toController, belowSubview: fromController)
            toController.frame = CGRect(x: 0, y: 0, width: containerView.frame.width, height: containerView.frame.height)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                fromController.frame = CGRect(x: containerView.frame.width / 2 , y: containerView.frame.height / 2, width: 80 , height: 80 )
                //fromController.transform = CGAffineTransform(rotationAngle: CGFloat(0 * Double.pi) / 360)
                //toController.superview?.alpha = 1
                fromController.layer.cornerRadius = fromController.frame.height / 2
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        }
    }
}
