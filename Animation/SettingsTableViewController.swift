//
//  SettingsTableViewController.swift
//  Animation
//
//  Created by Stephan Thordal Larsen on 20/08/15.
//  Copyright (c) 2015 Stephan Thordal Larsen. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    private let settings = Settings()
    
    // MARK: Ball settings
    @IBOutlet weak var radiusValueLabel: UILabel! {
        didSet {
            radiusValueLabel.text = "\(Int(settings.ballRadius))"
        }
    }
    
    @IBOutlet weak var radiusStepper: UIStepper! {
        didSet{
            radiusStepper.maximumValue = SettingBoundaries.radiusMaximum
            radiusStepper.minimumValue = SettingBoundaries.radiusMinimum
            radiusStepper.stepValue = SettingBoundaries.radiusStepValue
        }
    }
    
    @IBAction func radiusStepperChanged(sender: UIStepper) {
        radiusValueLabel.text = "\(Int(sender.value))"
        settings.ballRadius = CGFloat(sender.value)
    }
    
    @IBOutlet weak var throwForceSlider: UISlider! {
        didSet{
            throwForceSlider.maximumValue = SettingBoundaries.throwForceMaximum
            throwForceSlider.minimumValue = SettingBoundaries.throwForceMinimum
            throwForceSlider.value = Float(settings.ballThrowMagnitude)
        }
    }
    
    @IBAction func throwForceValueChanged(sender: UISlider) {
        settings.ballThrowMagnitude = CGFloat(sender.value)
    }
    
    
    // Mark: Brick settings
    @IBOutlet weak var brickRowValue: UILabel! {
        didSet {
            brickRowValue.text = "\(Int(settings.brickRowCount))"
        }
    }
    
    @IBOutlet weak var brickRowStepper: UIStepper! {
        didSet {
            brickRowStepper.minimumValue = SettingBoundaries.brickRowColumnMinimum
            brickRowStepper.maximumValue = SettingBoundaries.brickRowColumnMaximum
            brickRowStepper.stepValue = SettingBoundaries.brickRowColumnStepValue
            brickRowStepper.value = Double(settings.brickRowCount)
        }
    }
    
    @IBAction func brickRowStepperChanged(sender: UIStepper) {
        brickRowValue.text = "\(Int(sender.value))"
        settings.brickRowCount = Int(sender.value)
    }
    
    @IBOutlet weak var brickColumnValue: UILabel! {
        didSet {
            brickColumnValue.text = "\(Int(settings.bricksColumnCount))"
        }
    }

    @IBOutlet weak var brickColumnStepper: UIStepper! {
        didSet{
            brickColumnStepper.minimumValue = SettingBoundaries.brickRowColumnMinimum
            brickColumnStepper.maximumValue = SettingBoundaries.brickRowColumnMaximum
            brickColumnStepper.stepValue = SettingBoundaries.brickRowColumnStepValue
            brickColumnStepper.value = Double(settings.bricksColumnCount)
        }
    }
    
    @IBAction func brickColumnStepperChanged(sender: UIStepper) {
        brickColumnValue.text = "\(Int(sender.value))"
        settings.bricksColumnCount = Int(sender.value)
    }
    
    @IBOutlet weak var brickSpacingValue: UILabel! {
        didSet {
            brickSpacingValue.text = "\(Int(settings.brickSpacing))"
        }
    }
    
    @IBOutlet weak var brickSpacingStepper: UIStepper! {
        didSet {
            brickSpacingStepper.minimumValue = SettingBoundaries.brickRowColumnMinimum
            brickSpacingStepper.maximumValue = SettingBoundaries.brickRowColumnMaximum
            brickSpacingStepper.stepValue = SettingBoundaries.brickRowColumnStepValue
            brickSpacingStepper.value = Double(settings.brickSpacing)
        }
    }
    
    @IBAction func brickSpacingStepperChanged(sender: UIStepper) {
        brickSpacingValue.text = "\(Int(sender.value))"
        settings.brickSpacing = Int(sender.value)
    }
    
    private func getPercentage(numberValue : Double) -> String {
        return "\(numberValue * 100)%"
    }
    
    @IBOutlet weak var brickViewPercentageValue: UILabel! {
        didSet{
            brickViewPercentageValue.text = getPercentage(Double(settings.brickSpacing))
        }
    }
    
    @IBOutlet weak var brickViewPercentageStepper: UIStepper! {
        didSet {
            brickViewPercentageStepper.minimumValue = SettingBoundaries.brickPercentageMinimum
            brickViewPercentageStepper.maximumValue = SettingBoundaries.brickPercentageMaximum
            brickViewPercentageStepper.stepValue = SettingBoundaries.brickPercentageStepValue
            brickViewPercentageStepper.value = Double(settings.bricksViewPercentage)
        }
    }
    
    @IBAction func brickViewPercentageStepperChanged(sender: UIStepper) {
        brickViewPercentageValue.text = getPercentage(sender.value)
        settings.bricksViewPercentage = CGFloat(sender.value)
    }
    
    @IBOutlet weak var brickAnimationSegmented: UISegmentedControl! {
        didSet{
            let duration = settings.brickKillAnimationDuration
            if duration <= SettingBoundaries.brickAnimationFastValue {
                brickAnimationSegmented.selectedSegmentIndex = 0
            } else if duration <= SettingBoundaries.brickAnimationMediumValue {
                brickAnimationSegmented.selectedSegmentIndex = 1
            } else {
                brickAnimationSegmented.selectedSegmentIndex = 2
            }
        }
    }
    
    @IBAction func brickAnimationSegmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: settings.brickKillAnimationDuration = SettingBoundaries.brickAnimationSlowValue
        case 1: settings.brickKillAnimationDuration = SettingBoundaries.brickAnimationMediumValue
        case 2: settings.brickKillAnimationDuration = SettingBoundaries.brickAnimationFastValue
        default: break
        }
    }
    
    // MARK: Paddle settings
    
    @IBOutlet weak var paddleTallSwitch: UISwitch! {
        didSet{
            let tallness = Double(settings.paddleHeight)
            
            if tallness <= SettingBoundaries.paddleSwitchNotTallValue {
                paddleTallSwitch.setOn(false, animated: true)
            } else {
                paddleTallSwitch.setOn(true, animated: true)
            }
        }
    }
    
    @IBAction func paddleTallSwitchChanged(sender: UISwitch) {
        if sender.on {
            settings.paddleHeight = CGFloat(SettingBoundaries.paddleSwitchTallValue)
        } else {
            settings.paddleHeight = CGFloat(SettingBoundaries.paddleSwitchNotTallValue)
        }
    }
    
    @IBOutlet weak var paddleWidthSegmented: UISegmentedControl! {
        didSet {
            let paddleWidthPercentage = Double(settings.paddleWidthPercentage)
            
            if paddleWidthPercentage <= SettingBoundaries.paddleWidthPercentageNarrow {
                paddleWidthSegmented.selectedSegmentIndex = 0
            } else if paddleWidthPercentage <= SettingBoundaries.paddleWidthPercentageMedium {
                paddleWidthSegmented.selectedSegmentIndex = 1
            } else {
                paddleWidthSegmented.selectedSegmentIndex = 2
            }
        }
    }
    
    @IBAction func paddleWidthSegmentChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1: settings.paddleWidthPercentage = CGFloat(SettingBoundaries.paddleWidthPercentageNarrow)
        case 2: settings.paddleWidthPercentage = CGFloat(SettingBoundaries.paddleWidthPercentageMedium)
        case 3: settings.paddleWidthPercentage = CGFloat(SettingBoundaries.paddleWidthPercentageWide)
        default: break
        }
    }

    
    private struct SettingBoundaries {
        static let radiusMinimum : Double = 5.0
        static let radiusMaximum : Double = 50.0
        static let radiusStepValue : Double = 1.0
        static let throwForceMinimum : Float = 0.0
        static let throwForceMaximum : Float = 2.0
        static let brickRowColumnMinimum : Double = 1
        static let brickRowColumnMaximum : Double = 100
        static let brickRowColumnStepValue : Double = 1
        static let brickPercentageMinimum : Double = 0.0
        static let brickPercentageMaximum : Double = 1.0
        static let brickPercentageStepValue : Double = 0.1
        static let brickAnimationSlowValue : Double = 0.6
        static let brickAnimationMediumValue : Double = 0.4
        static let brickAnimationFastValue : Double = 0.2
        static let paddleSwitchNotTallValue : Double = 50
        static let paddleSwitchTallValue : Double = 200
        static let paddleWidthPercentageNarrow : Double = 0.2
        static let paddleWidthPercentageMedium : Double = 0.4
        static let paddleWidthPercentageWide : Double = 0.6
        
    }
    
    static let paddleWidthPercentage = "Breakout.PaddleWidthPercentage"
    static let paddleHeight = "Breakout.PaddleHeight"
    static let paddleFloat = "Breakout.PaddleFloat"
    
    static let ballRadius = "Breakout.BallRadius"
    static let ballThrowMagnitude = "Breakout.BallThrowMagnitude"
    
    static let brickRowCount = "Breakout.BrickRowCount"
    static let bricksColumnCount = "Breakout.BrickColumnCount"
    static let brickSpacing = "Breakout.BrickSpacing"
    static let bricksViewPercentage = "Breakout.BrickViewPercentage"
    static let brickKillAnimationDuration = "Breakout.BrickKillAnimationDuration"
}
