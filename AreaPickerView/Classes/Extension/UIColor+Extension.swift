//
//  UIColor+Extension.swift
//  Remind
//
//  Created by sessionCh on 2018/4/17.
//  Copyright © 2018年 ganyi. All rights reserved.
//

import Foundation

extension UIColor {
    
    ///统一背景颜色
    static let bgColor = UIColor(colorHex: 0xf5f5f7, alpha: 1)
    ///背景颜色（日历选择器背景）(添加事件背景)
    static let headerBg = UIColor(colorHex: 0xe6e6e6, alpha: 1)
    
    ///标题文字颜色
    static let word = UIColor(colorHex: 0x222222, alpha: 1)
    ///内容文字颜色
    static let subWord = UIColor(colorHex: 0x666666, alpha: 1)
    ///确认按钮颜色（确定、保存）
    static let confirm = UIColor(colorHex: 0xff8000, alpha: 1)
}

extension UIColor {
    convenience init(colorHex hex: UInt, alpha: CGFloat = 1) {
        var aph = alpha
        if aph < 0 {
            aph = 0
        }
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255,
                  blue: CGFloat(hex & 0x0000FF) / 255,
                  alpha: alpha)
    }
    
    convenience init(colorHexStr hexStr: String, alpha: CGFloat = 1){
        let t = UIColor.hexTorgb(hexStr, alpha: alpha)
        self.init(red: t[0], green: t[1],blue: t[2], alpha: t[3])
    }
    
    class func hexTorgb(_ rgbValue: String,alpha: CGFloat) -> [CGFloat] {
        var  Str :NSString = rgbValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
        if rgbValue.hasPrefix("0x"){
            Str=(rgbValue as NSString).substring(from: 2) as NSString
        }else if rgbValue.hasPrefix("#"){
            Str=(rgbValue as NSString).substring(from: 1) as NSString
        }else{
            return [0, 0, 0, 0]
        }
        if Str.length != 6 {
            return [0, 0, 0, 0]
        }
        let red = (Str as NSString ).substring(to: 2)
        let green = ((Str as NSString).substring(from: 2) as NSString).substring(to: 2)
        let blue = ((Str as NSString).substring(from: 4) as NSString).substring(to: 2)
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string:red).scanHexInt32(&r)
        Scanner(string: green).scanHexInt32(&g)
        Scanner(string: blue).scanHexInt32(&b)
        return [CGFloat(r)/255.0, CGFloat(g)/255.0, CGFloat(b)/255.0, alpha]
    }
}
