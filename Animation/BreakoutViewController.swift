//
//  BreakoutViewController.swift
//  Animation
//
//  Created by Stephan Thordal Larsen on 15/08/15.
//  Copyright (c) 2015 Stephan Thordal Larsen. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var breakoutView: UIView!
    
    // MARK: Animators and Behaviors
    private lazy var animator : UIDynamicAnimator = {
        let lazyAnimator = UIDynamicAnimator(referenceView: self.breakoutView)
        lazyAnimator.delegate = self
        return lazyAnimator
    }()
    
    private let ballBehavior = BreakoutBallBehavior()
    
    // MARK: Bricks
    let brickRowCount : CGFloat = 4
    let bricksColumnCount : CGFloat = 8
    let brickSpacing : CGFloat = 20
    
    let bricksViewPercentage : CGFloat = 0.3
    
    var brickSize : CGSize {
        let height = breakoutView.bounds.size.height * bricksViewPercentage / brickRowCount - brickSpacing
        let width = breakoutView.bounds.size.width / bricksColumnCount - brickSpacing
        return CGSize(width: width, height: height)
    }
    
    // MARK: Balls
    let ballRadius : CGFloat = 10
    var balls = [UIView]()
    
    func tapAddBall(gesture: UITapGestureRecognizer) {
        addBall(gesture.locationInView(breakoutView))
    }
    
    func addBall(origin: CGPoint) {
        //TODO: Create round ball and add it to the breakoutview
        let ball = UIView()
        ball.center = origin
        ball.bounds.origin = origin
        ball.bounds.size.height = ballRadius * 2
        ball.bounds.size.width = ballRadius * 2
        ball.layer.cornerRadius = ballRadius
        ball.backgroundColor = UIColor.randomGirlish
//        let ball = UIBezierPath(arcCenter: origin, radius: ballRadius, startAngle: 90, endAngle: 90, clockwise: true)
        ballBehavior.addBall(ball)
        breakoutView.addSubview(ball)
        balls.append(ball)
        breakoutView.setNeedsDisplay()
    }
    
    func tapThrowBalls(gesture: UITapGestureRecognizer) {
        throwBalls()
    }
    
    func throwBalls() {
        for ball in balls {
            
        }
    }
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(ballBehavior)
        breakoutView.addGestureRecognizer(doubleTapGestureRecognizer)
        breakoutView.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    // MARK: Dynamic Animator Delegation
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        //TODO: Do something when pausing
    }
    
    func dynamicAnimatorWillResume(animator: UIDynamicAnimator) {
        //TODO: Do something on resuming
    }
    
    // MARK: Gesture Recognizers
    private struct GestureActionSelectors {
        static let DoubleTapAction : Selector = "tapAddBall:"
        static let SingleTapAction : Selector = "tapThrowBalls:"
    }
    
    private lazy var doubleTapGestureRecognizer : UITapGestureRecognizer = { [unowned self] in
        var lazyDoubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: GestureActionSelectors.DoubleTapAction)
        lazyDoubleTapGestureRecognizer.numberOfTapsRequired = 2
        return lazyDoubleTapGestureRecognizer
    }()
    
    private lazy var singleTapGestureRecognizer : UITapGestureRecognizer = { [unowned self] in
        var lazySingleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: GestureActionSelectors.SingleTapAction)
        lazySingleTapGestureRecognizer.numberOfTapsRequired = 1
        lazySingleTapGestureRecognizer.requireGestureRecognizerToFail(self.doubleTapGestureRecognizer)
        return lazySingleTapGestureRecognizer
    }()
    
    // MARK: Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

private extension UIColor {
    class var randomGirlish : UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.yellowColor()
        case 1: return UIColor.purpleColor()
        case 2: return UIColor.magentaColor()
        case 3: return UIColor.orangeColor()
        case 4: return UIColor.redColor()
        default: return UIColor.blackColor()
        }
    }
    
    class var randomBoyish : UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.brownColor()
        case 3: return UIColor.grayColor()
        default: return UIColor.blackColor()
        }
    }

}
