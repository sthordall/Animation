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
    let settings = Settings()
    
    private func paddleSize(view : UIView) -> CGSize {
        let width = view.bounds.size.width * settings.paddleWidthPercentage
        return CGSize(width: width, height: settings.paddleHeight)
    }
    
    // MARK: Breakout game constants
    private struct BreakoutIdentifiers {
        static let paddleBarrierName : String = "BreakoutPaddle"
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
        if let id = identifier as? String {
            if let brick = bricks.removeValueForKey(id) {
                UIView.transitionWithView(brick, duration: settings.brickKillAnimationDuration, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {brick.backgroundColor = UIColor.randomGirlish}, completion: { (_) -> Void in
                    UIView.animateWithDuration(self.settings.brickKillAnimationDuration,
                        delay: 0,
                        options: UIViewAnimationOptions.CurveEaseOut,
                        animations: {brick.alpha = 0.0},
                        completion: { (_) -> Void in
                            brick.removeFromSuperview()
                            self.ballBehavior.removeBarrier(named: id)
                    })
                })
            }
            if bricks.count <= 0 {
                gameOver()
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
        
        ballBehavior.addBarrier(leftTop, toPoint: leftBottom, named: BreakoutIdentifiers.leftViewBarrierIdentifier)
        ballBehavior.addBarrier(rightTop, toPoint: rightBottom, named: BreakoutIdentifiers.rightViewBarrierIdentifier)
        ballBehavior.addBarrier(leftTop, toPoint: rightTop, named: BreakoutIdentifiers.topViewBarrierIdentifier)
    }
    
    // MARK: Paddle
    
    var paddle : UIView?
    
    func createPaddle() -> UIView {
        var paddle = UIView()
        paddle.center =  CGPoint(x: breakoutView.bounds.midX, y: breakoutView.bounds.maxY - settings.paddleFloat - settings.paddleHeight)
        paddle.bounds.size = paddleSize(breakoutView)
        paddle.backgroundColor = UIColor.randomBoyish
        return paddle
    }
  
    func grabPaddle(gesture : UIPanGestureRecognizer) {
        let gesturePoint = gesture.locationInView(breakoutView)
        switch gesture.state {
        case .Began: fallthrough
        case .Changed:
            paddle?.center.x = gesturePoint.x
            addPaddle()
        default: break
        }
    }
    
    func addPaddle() {
        if paddle == nil {
            paddle = createPaddle()
            breakoutView.addSubview(paddle!)
        }
        ballBehavior.addBarrier(UIBezierPath(rect: paddle!.frame), named: BreakoutIdentifiers.paddleBarrierName)
    }
    
    func removePaddle() {
        paddle?.removeFromSuperview()
        paddle = nil
    }
    
    // MARK: Bricks
    var bricks = [String:UIView]()
    
    func setupBricks() {
        let brickWidth = breakoutView.bounds.width / CGFloat(settings.bricksColumnCount)
                        - CGFloat(settings.brickSpacing);
        let brickHeight = breakoutView.bounds.height * CGFloat(settings.bricksViewPercentage)
                        / CGFloat(settings.brickRowCount) - CGFloat(settings.brickSpacing);
        
        for column in 0..<settings.bricksColumnCount {
            for row in 0..<settings.brickRowCount {
                let brickOriginX = breakoutView.bounds.minX + CGFloat(column) * brickWidth + CGFloat(column) * CGFloat(settings.brickSpacing) + CGFloat(settings.brickSpacing/2)
                let brickOriginY = breakoutView.bounds.minY + CGFloat(row) * brickHeight + CGFloat(row) * CGFloat(settings.brickSpacing) + CGFloat(settings.brickSpacing/2)
                let brickFrame = CGRect(x: brickOriginX, y: brickOriginY, width: brickWidth, height: brickHeight)
                let brickView = UIView(frame: brickFrame)
                brickView.backgroundColor = UIColor.randomBoyish
                let brickBarrierIdentifier = BreakoutIdentifiers.brickBarrierIdentifierPrefix + "_\(column)_\(row)"
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
        ball.bounds.size.height = settings.ballRadius * 2
        ball.bounds.size.width = settings.ballRadius * 2
        ball.layer.cornerRadius = settings.ballRadius
        ball.backgroundColor = UIColor.randomGirlish
        ballBehavior.addBall(ball)
        balls.append(ball)
        breakoutView.setNeedsDisplay()
    }
    
    func tapThrowBalls(gesture: UITapGestureRecognizer) {
        throwBalls()
    }
    
    func throwBalls() {
        ballBehavior.throwBalls(settings.ballThrowMagnitude)
    }
    
    // MARK: Game Lifecycle
    private struct BreakoutGameLabels {
        static let GameOverTitle = "Game Over"
        static let PlayAgainTitle = "Play Again"
        static let GameOverMessage = "You've destroyed all the bricks! Touch below to play again."
    }
    
    private func startGame() {
        addPaddle()
        setupBricks()
        setupViewBarriers()
    }
    
    private func removeGame() {
        removePaddle()
        ballBehavior.removeAllBarriers()
        for view in breakoutView.subviews {
            view.removeFromSuperview()
        }
        for ball in balls {
            ball.removeFromSuperview()
        }
    }
    
    private func gameOver() {
        for ball in ballBehavior.balls {
            ballBehavior.removeBall(ball)
        }
        let gameOverModalController = UIAlertController(title: BreakoutGameLabels.GameOverTitle, message: BreakoutGameLabels.GameOverMessage, preferredStyle: .Alert)
        gameOverModalController.addAction(UIAlertAction(title: BreakoutGameLabels.PlayAgainTitle, style: .Default, handler: { (action) in
            self.removeGame()
            self.startGame()
        }))
        presentViewController(gameOverModalController, animated: true, completion: nil)
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
        startGame()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeGame()
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
