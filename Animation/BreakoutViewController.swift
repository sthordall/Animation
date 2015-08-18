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
    
    // MARK: Breakout game constants
    private struct BreakoutSettings {
        static let paddleWidthPercentage : CGFloat = 0.15
        static let paddleHeight : CGFloat = 15
        static let paddleFloat : CGFloat = -50
        static func paddleSize(view : UIView) -> CGSize {
            let width = view.bounds.size.width * paddleWidthPercentage
            return CGSize(width: width, height: paddleHeight)
        }
        static let paddleBarrierName = "BreakoutPaddle"
        
        static let ballRadius : CGFloat = 10
        static let ballThrowMagnitude : CGFloat = 0.5
        
        static let brickRowCount : CGFloat = 4
        static let bricksColumnCount : CGFloat = 8
        static let brickSpacing : CGFloat = 20
        
        static let bricksViewPercentage : CGFloat = 0.3
        
        static func brickSize(view: UIView) -> CGSize {
            let height = view.bounds.size.height * bricksViewPercentage / brickRowCount - brickSpacing
            let width = view.bounds.size.width / bricksColumnCount - brickSpacing
            return CGSize(width: width, height: height)
        }
    }
    
    // MARK: Animators and Behaviors
    private lazy var animator : UIDynamicAnimator = { [unowned self] in
        let lazyAnimator = UIDynamicAnimator(referenceView: self.breakoutView)
        lazyAnimator.delegate = self
        return lazyAnimator
    }()
    
    private let ballBehavior = BreakoutBallBehavior()
    
    // MARK: Paddle
    private lazy var paddle : UIView = { [unowned self] in
        var lazyPaddle = UIView()
        lazyPaddle.center =  CGPoint(x: self.breakoutView.bounds.midX, y: self.breakoutView.bounds.maxY - BreakoutSettings.paddleFloat - BreakoutSettings.paddleHeight)
        lazyPaddle.bounds.size = BreakoutSettings.paddleSize(self.breakoutView)
        lazyPaddle.backgroundColor = UIColor.randomBoyish
        return lazyPaddle
    }()
   
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
        ballBehavior.throwBalls(balls, magnitude: BreakoutSettings.ballThrowMagnitude)
    }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        animator.addBehavior(ballBehavior)
        breakoutView.addGestureRecognizer(doubleTapGestureRecognizer)
        breakoutView.addGestureRecognizer(singleTapGestureRecognizer)
        breakoutView.addGestureRecognizer(panGestureRecognizer)
        breakoutView.addSubview(paddle)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
