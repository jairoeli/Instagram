//
//  CustomAnimation.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/29/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class CustomAnimationPresenter: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // custom transition animation
    let containerView = transitionContext.containerView
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    guard let toView = transitionContext.view(forKey: .to) else { return }
    
    containerView.addSubview(toView)
    
    let startingFrame = CGRect(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
    
    toView.frame = startingFrame
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
      // animation
      
      toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
      fromView.frame = CGRect(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
      
    }) { (_) in
      transitionContext.completeTransition(true)
    }
    
  }
  
}
