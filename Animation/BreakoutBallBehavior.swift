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
        lazyCollider.action = {
            for ball in self.balls {
                if !CGRectIntersectsRect(self.dynamicAnimator!.referenceView!.bounds, ball.frame) {
                    self.removeBall(ball)
                }
            }
        }
        return lazyCollider
    }()
    private lazy var ballBehavior : UIDynamicItemBehavior = {
        let lazyBehavior = UIDynamicItemBehavior()
        lazyBehavior.elasticity = self.ballElasticity
        lazyBehavior.friction = self.ballFriction
        lazyBehavior.resistance = self.ballResistance
        lazyBehavior.allowsRotation = self.ballRotation
        return lazyBehavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(gravity)
        addChildBehavior(collider)
        addChildBehavior(ballBehavior)
    }
    
    // MARK: Public API
    
    var ballElasticity : CGFloat = 1
    var ballFriction : CGFloat = 0
    var ballResistance : CGFloat = 0
    var ballRotation = false
    var balls = [UIView]()
    
    func addBall(ball : UIView) {
        dynamicAnimator?.referenceView?.addSubview(ball)
        gravity.addItem(ball)
        collider.addItem(ball)
        ballBehavior.addItem(ball)
        balls.append(ball)
    }
    
    func removeBall(ball : UIView) {
        gravity.removeItem(ball)
        collider.removeItem(ball)
        ballBehavior.removeItem(ball)
        ball.removeFromSuperview()
        balls.removeAtIndex(find(balls, ball)!)
    }
    
    func throwBalls(magnitude : CGFloat) {
        let balls = ballBehavior.items as? [UIView]
        let throw = UIPushBehavior(items: balls, mode: UIPushBehaviorMode.Instantaneous)
        throw.magnitude = magnitude
        throw.angle = CGFloat.randomAngle()
        throw.action = { [weak throw, unowned self] in
            if !throw!.active {
                self.removeChildBehavior(throw!)
            }
        }
        addChildBehavior(throw)
    }
    
    func addBarrier(path: UIBezierPath, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, forPath: path)
    }
    
    func addBarrier(fromPoint: CGPoint, toPoint: CGPoint, named name: String) {
        collider.removeBoundaryWithIdentifier(name)
        collider.addBoundaryWithIdentifier(name, fromPoint: fromPoint, toPoint: toPoint)
    }
    
    func removeBarrier(named name: String) {
        collider.removeBoundaryWithIdentifier(name)
    }
    
    func assignCollisionBehviorDelegate(delegate: UICollisionBehaviorDelegate) {
        collider.collisionDelegate = delegate
    }
}

private extension CGFloat {
    static func randomAngle() -> CGFloat {
        return CGFloat(Double(arc4random()) * M_PI * 2 / Double(UINT32_MAX))
    }
}
