//
//  BreakoutViewController.swift
//  Animation
//
//  Created by Stephan Thordal Larsen on 15/08/15.
//  Copyright (c) 2015 Stephan Thordal Larsen. All rights reserved.
//

import UIKit

class BreakoutViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate {

    @IBOutlet weak var breakoutView: UIView!
    
    // MARK: Breakout game constants
    private struct BreakoutSettings {
        static let paddleWidthPercentage : CGFloat = 0.8
        static let paddleHeight : CGFloat = 15
        static let paddleFloat : CGFloat = 10
        static func paddleSize(view : UIView) -> CGSize {
            let width = view.bounds.size.width * paddleWidthPercentage
            return CGSize(width: width, height: paddleHeight)
        }
        static let paddleBarrierName : String = "BreakoutPaddle"
        
        static let ballRadius : CGFloat = 10
        static let ballThrowMagnitude : CGFloat = 0.5
        
        static let brickRowCount = 10
        static let bricksColumnCount = 15
        static let brickSpacing = 1
        static let bricksViewPercentage : CGFloat = 0.5
        static let brickKillAnimationDuration = 0.8
        static let brickBarrierIdentifierPrefix = "brickbarrier"
        
        static let leftViewBarrierIdentifier = "Left Barrier"
        static let rightViewBarrierIdentifier = "Right Barrier"
        static let topViewBarrierIdentifier = "Top Barrier"
    }
    
    // MARK: Animators and Behaviors
    private lazy var animator : UIDynamicAnimator = { [unowned self] in
        let lazyAnimator = UIDynamicAnimator(referenceView: self.breakoutView)
        lazyAnimator.delegate = self
        return lazyAnimator
    }()
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
        print(identifier)
        if let id = identifier as? String {
            if let brick = bricks.removeValueForKey(id) {
                UIView.transitionWithView(brick, duration: BreakoutSettings.brickKillAnimationDuration, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {brick.backgroundColor = UIColor.randomGirlish}, completion: { (_) -> Void in
                    UIView.animateWithDuration(BreakoutSettings.brickKillAnimationDuration,
                        delay: 0,
                        options: UIViewAnimationOptions.CurveEaseOut,
                        animations: {brick.alpha = 0.0},
                        completion: { (_) -> Void in
                            brick.removeFromSuperview()
                            self.ballBehavior.removeBarrier(named: id)
                    })
                })
            }
        }
        
    }
    
    private let ballBehavior = BreakoutBallBehavior()
    
    // MARK: View Barriers
    func setupViewBarriers() {
        let leftTop = CGPoint(x: breakoutView.bounds.minX, y: breakoutView.bounds.minY)
        let leftBottom = CGPoint(x: breakoutView.bounds.minX, y: breakoutView.bounds.maxY)
        let rightTop = CGPoint(x: breakoutView.bounds.maxX, y: breakoutView.bounds.minY)
        let rightBottom = CGPoint(x: breakoutView.bounds.maxX, y: breakoutView.bounds.maxY)
        
        ballBehavior.addBarrier(leftTop, toPoint: leftBottom, named: BreakoutSettings.leftViewBarrierIdentifier)
        ballBehavior.addBarrier(rightTop, toPoint: rightBottom, named: BreakoutSettings.rightViewBarrierIdentifier)
        ballBehavior.addBarrier(leftTop, toPoint: rightTop, named: BreakoutSettings.topViewBarrierIdentifier)
    }
    
    // MARK: Paddle
    private lazy var paddle : UIView = { [unowned self] in
        var lazyPaddle = UIView()
        lazyPaddle.center =  CGPoint(x: self.breakoutView.bounds.midX, y: self.breakoutView.bounds.maxY - BreakoutSettings.paddleFloat - BreakoutSettings.paddleHeight)
        lazyPaddle.bounds.size = BreakoutSettings.paddleSize(self.breakoutView)
        lazyPaddle.backgroundColor = UIColor.randomBoyish
        return lazyPaddle
    }()
    
    private var paddleHasBeenAdded = false
   
    func grabPaddle(gesture : UIPanGestureRecognizer) {
        let gesturePoint = gesture.locationInView(breakoutView)
        switch gesture.state {
        case .Began: fallthrough
        case .Changed:
            paddle.center.x = gesturePoint.x
            addPaddleBarrier()
        default: break
        }
    }
    
    private func placePaddle(translation: CGPoint) {
        var origin = paddle.frame.origin
        origin.x = max(min(origin.x + translation.x, breakoutView.bounds.maxX - BreakoutSettings.paddleSize(breakoutView).width), 0.0)
        paddle.frame.origin = origin
        addPaddleBarrier()
    }
    
    private func addPaddleBarrier() {
        ballBehavior.addBarrier(UIBezierPath(rect: paddle.frame), named: BreakoutSettings.paddleBarrierName)
    }
    
    // MARK: Bricks
    var bricks = [String:UIView]()
    
    func setupBricks() {
        let brickWidth = breakoutView.bounds.width / CGFloat(BreakoutSettings.bricksColumnCount)
                        - CGFloat(BreakoutSettings.brickSpacing);
        let brickHeight = breakoutView.bounds.height * CGFloat(BreakoutSettings.bricksViewPercentage)
                        / CGFloat(BreakoutSettings.brickRowCount) - CGFloat(BreakoutSettings.brickSpacing);
        
        for column in 0..<BreakoutSettings.bricksColumnCount {
            for row in 0..<BreakoutSettings.brickRowCount {
                let brickOriginX = breakoutView.bounds.minX + CGFloat(column) * brickWidth + CGFloat(column) * CGFloat(BreakoutSettings.brickSpacing) + CGFloat(BreakoutSettings.brickSpacing/2)
                let brickOriginY = breakoutView.bounds.minY + CGFloat(row) * brickHeight + CGFloat(row) * CGFloat(BreakoutSettings.brickSpacing) + CGFloat(BreakoutSettings.brickSpacing/2)
                let brickFrame = CGRect(x: brickOriginX, y: brickOriginY, width: brickWidth, height: brickHeight)
                let brickView = UIView(frame: brickFrame)
                brickView.backgroundColor = UIColor.randomBoyish
                let brickBarrierIdentifier = BreakoutSettings.brickBarrierIdentifierPrefix + "_\(column)_\(row)"
                bricks.updateValue(brickView, forKey: brickBarrierIdentifier)
                breakoutView.addSubview(brickView)
                ballBehavior.addBarrier(UIBezierPath(rect: brickFrame), named: brickBarrierIdentifier)
            }
        }
    }
    
    // MARK: Balls
    
    var balls = [UIView]()
    
    func tapAddBall(gesture: UITapGestureRecognizer) {
        addBall(gesture.locationInView(breakoutView))
    }
    
    func addBall(origin: CGPoint) {
        let ball = UIView()
        ball.center = origin
        ball.bounds.size.height = BreakoutSettings.ballRadius * 2
        ball.bounds.size.width = BreakoutSettings.ballRadius * 2
        ball.layer.cornerRadius = BreakoutSettings.ballRadius
        ball.backgroundColor = UIColor.randomGirlish
        ballBehavior.addBall(ball)
        balls.append(ball)
        breakoutView.setNeedsDisplay()
    }
    
    func tapThrowBalls(gesture: UITapGestureRecognizer) {
        throwBalls()
    }
    
    func throwBalls() {
        ballBehavior.throwBalls(BreakoutSettings.ballThrowMagnitude)
    }
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(ballBehavior)
        breakoutView.addGestureRecognizer(doubleTapGestureRecognizer)
        breakoutView.addGestureRecognizer(singleTapGestureRecognizer)
        breakoutView.addGestureRecognizer(panGestureRecognizer)
        ballBehavior.assignCollisionBehviorDelegate(self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        breakoutView.addSubview(paddle)
        setupBricks()
        setupViewBarriers()
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
        static let PanAction : Selector = "grabPaddle:"
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
    
    private lazy var panGestureRecognizer : UIPanGestureRecognizer = { [unowned self] in
        var lazyPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: GestureActionSelectors.PanAction)
        return lazyPanGestureRecognizer
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
