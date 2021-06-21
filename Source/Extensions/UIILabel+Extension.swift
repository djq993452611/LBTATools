//
//  UIILabel+Extension.swift
//  POP-UIViewStyleExtension
//
//  Created by    on 2017/7/3.
//  Copyright © 2017年   . All rights reserved.
//

import UIKit

public extension UILabel {
    
    //构造初始化
    convenience init(text: String, color: UIColor, font: UIFont, alignment: NSTextAlignment? = .left, numberOfLines: Int? = 1) {
        self.init(frame: .zero)
        self.font = font
        self.text = text
        self.textColor = color
        self.textAlignment = alignment ?? .left
        self.numberOfLines = numberOfLines ?? 1
        
    }
    
    //MARK:UILabel上的多种颜色字体实现(有多段内容就多次执行方法)
    //subContent--多颜色的内容
    func makeupMultipleColor(subContent: String, color: UIColor, font: UIFont) {
        
        //1.先把String转换成 NSStiring
        let nsString = NSString(string: self.text ?? "")
        //2.NSString中的range方法获取到的是NSRange类型
        let nsRange = nsString.range(of: subContent)
        
        //3.根据是否已经有多颜色的attributedText，给aStr赋值
        //已经有颜色属性，保留已经设置过的效果
        var aStr: NSMutableAttributedString
        if let attStr = self.attributedText {
            aStr = NSMutableAttributedString.init(attributedString: attStr)
        }else {
            aStr = NSMutableAttributedString.init(string: nsString as String)
        }
        
        aStr.addAttributes([NSAttributedString.Key.foregroundColor: color], range: nsRange)
        aStr.addAttributes([NSAttributedString.Key.font: font], range: nsRange)
        self.attributedText = aStr
        
    }
}

