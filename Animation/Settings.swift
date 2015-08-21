//
//  Settings.swift
//  Animation
//
//  Created by Stephan Thordal Larsen on 20/08/15.
//  Copyright (c) 2015 Stephan Thordal Larsen. All rights reserved.
//

import Foundation
import UIKit

class Settings {
    private var userDefaults = NSUserDefaults()

    struct UserDefaultKeys {
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
    
    struct SettingsDefaults {
        static let paddleWidthPercentage : CGFloat = 0.8
        static let paddleHeight : CGFloat = 15
        static let paddleFloat : CGFloat = 10
        
        static let ballRadius : CGFloat = 10
        static let ballThrowMagnitude : CGFloat = 0.5
        
        static let brickRowCount = 2
        static let bricksColumnCount = 2
        static let brickSpacing = 1
        static let bricksViewPercentage : CGFloat = 0.5
        static let brickKillAnimationDuration = 0.8

    }

    var paddleWidthPercentage : CGFloat {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.paddleWidthPercentage) as? CGFloat {
                return data
            } else {
                return SettingsDefaults.paddleWidthPercentage
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.paddleWidthPercentage)
        }
    }
    
    var paddleHeight : CGFloat {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.paddleHeight) as? CGFloat {
                return data
            } else {
                return SettingsDefaults.paddleHeight
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.paddleHeight)
        }
    }
    
    var paddleFloat : CGFloat {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.paddleFloat) as? CGFloat {
                return data
            } else {
                return SettingsDefaults.paddleFloat
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.paddleFloat)
        }
    }

    var ballRadius : CGFloat {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.ballRadius) as? CGFloat {
                return data
            } else {
                return SettingsDefaults.ballRadius
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.ballRadius)
        }
    }
    
    var ballThrowMagnitude : CGFloat {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.ballThrowMagnitude) as? CGFloat {
                return data
            } else {
                return SettingsDefaults.ballThrowMagnitude
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.ballThrowMagnitude)
        }
    }

    var brickRowCount : Int {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.brickRowCount) as? Int {
                return data
            } else {
                return SettingsDefaults.brickRowCount
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.brickRowCount)
        }
    }
    
    var bricksColumnCount : Int {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.bricksColumnCount) as? Int {
                return data
            } else {
                return SettingsDefaults.bricksColumnCount
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.bricksColumnCount)
        }
    }
    
    var brickSpacing : Int {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.brickSpacing) as? Int {
                return data
            } else {
                return SettingsDefaults.brickSpacing
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.brickSpacing)
        }
    }
        
    var bricksViewPercentage : CGFloat {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.bricksViewPercentage) as? CGFloat {
                return data
            } else {
                return SettingsDefaults.bricksViewPercentage
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.bricksViewPercentage)
        }
    }
        
    var brickKillAnimationDuration : Double {
        get {
            if let data = userDefaults.objectForKey(UserDefaultKeys.brickKillAnimationDuration) as? Double {
                return data
            } else {
                return SettingsDefaults.brickKillAnimationDuration
            }
        }
        set{
            userDefaults.setObject(newValue, forKey: UserDefaultKeys.brickKillAnimationDuration)
        }
    }

}
