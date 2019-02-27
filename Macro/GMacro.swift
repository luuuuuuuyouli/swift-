//
//  GMacro.swift
//  Base
//
//  Created by daihz on 2019/2/20.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit

func printg<mes>(_ message: mes, fileName: String = #file, methodName: String = #function,l ineNumber: Int = #line){
    #if DebugType
    //    print("类:\(fileName.components(separatedBy: "/").last! as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n\(message)");
    print("\(message)");
    #endif
}

// MARK: - FilePath
let tempPath = NSTemporaryDirectory()
let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]  

// MARK: - Screen
//屏幕大小
func SCREEN_SIZE() -> CGSize { return UIScreen.main.bounds.size }
//屏幕宽
func SCREEN_WIDTH() -> CGFloat { return UIScreen.main.bounds.size.width }
//屏幕高
func SCREEN_HEIGHT() -> CGFloat { return UIScreen.main.bounds.size.height }
//导航栏高度
func NAV_HEIGHT() -> CGFloat { return STATUS_BAR_HEIGHT() + 44 }
//状态栏高度
func STATUS_BAR_HEIGHT() -> CGFloat { return SCREEN_HEIGHT()>=812 ? 44 : 20 }
//等比宽
func WIDTH_CONSTARIN(width: CGFloat) -> CGFloat { return  SCREEN_WIDTH()/375.0*width }
//等比高
func HEIGHT_CONSTARIN(height:CGFloat) -> CGFloat { return (SCREEN_HEIGHT()-(SCREEN_HEIGHT() >= 812 ? 56 : 0))/667.0 * height }

// MARK: - Color
func COLOR_RGB(r: CGFloat,g: CGFloat,b: CGFloat,a: CGFloat) -> UIColor {
    return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
//16进制
func COLOR_16(value: uint) -> UIColor {
    return UIColor.init(red: CGFloat((value & 0xFF0000) >> 16) / 255.0, green: CGFloat((value & 0x00FF00) >> 8) / 255.0, blue: CGFloat(value & 0x0000FF) / 255.0, alpha: 1.0)
}

// MARK: - 类型转换

func stringValue(_ obj: Any?) -> String {
    return "\(obj ?? "")"
}
func dictionaryValue(_ obj: Any?) -> Dictionary<String, Any> {
    if let newDictionary = obj as? Dictionary<String, Any> {
        return newDictionary
    }else{
        return ["":""]
    }
}
func arrayValue(_ obj: Any?) -> Array<Any> {
    if let newArray = obj as? Array<Any> {
        return newArray
    }else{
        return []
    }
}
func intValue(_ obj: Any?) -> Int {
    if let newValue = Int(stringValue(obj)) {
        return newValue
    }else{
        return 0
    }
}
func floatValue(_ obj: Any?) -> Float {
    if let newValue = Float(stringValue(obj)) {
        return newValue
    }else{
        return Float(0)
    }
}

// MARK: - Default

let defaultDateFormat = "yyyy-MM-dd HH:mm:ss"

let defaultColor = UIColor.white
