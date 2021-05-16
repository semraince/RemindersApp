//
//  ColorHelper.swift
//  RemindersApp
//
//

import Foundation
import UIKit

func uiColorFromHex(rgbValue: Int) -> UIColor {
    
    let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
    let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
    let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
    let alpha = CGFloat(1.0)
    
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
}
