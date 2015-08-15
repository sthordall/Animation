//
//  BreakoutBehavior.swift
//  Animation
//
//  Created by Stephan Thordal Larsen on 15/08/15.
//  Copyright (c) 2015 Stephan Thordal Larsen. All rights reserved.
//

import UIKit

class BreakoutBallBehavior: UIDynamicBehavior {
    private var gravity = UIGravityBehavior()
    private lazy var collider : UICollisionBehavior = {
        let lazyCollider = UICollisionBehavior()
        lazyCollider.translatesReferenceBoundsIntoBoundary = true
        return lazyCollider
    }()
    private lazy var ballBehavior : UIDynamicItemBehavior = {
        let lazyBehavior = UIDynamicItemBehavior()
        lazyBehavior.allowsRotation = true
        lazyBehavior.elasticity = CGFloat(self.ballElasticity)
        return lazyBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    // MARK: Public API
    
    var ballElasticity = 0.5
    
    func addBall(ball : UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        gravity.addItem(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
    }
    
    func removeBall(ball : UIView) {
        gravity.removeItem(ball)
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
    }
}
