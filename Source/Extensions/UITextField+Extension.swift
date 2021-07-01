//
//  UITextField+Extension.swift
//  ETM
//
//  Created by    on 2018/9/18.
//  Copyright © 2018年   . All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    @IBInspectable public var holderColr: UIColor? {
        get {
            return self.attributedPlaceholder!.attributes(at: 0, effectiveRange: nil)[NSAttributedString.Key.foregroundColor] as? UIColor
        }
        set {
            if newValue != nil {
                setPlaceHolderTextColor(newValue!)
            }
        }
        
    }
    
    private func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    convenience init(textColor: UIColor, font: UIFont, holderText: String, holdColor:UIColor) {
        self.init(frame: .zero)
        self.font = font
        self.textColor = textColor
        self.setPlaceHolderTextColor(holdColor)
        self.placeholder = holderText
        self.clearButtonMode = .whileEditing
       //self.borderStyle = .roundedRect
    
    }
    
    convenience init(textColor: UIColor, font: UIFont, alignment: NSTextAlignment){
        self.init(frame: .zero)
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
        self.clearButtonMode = .whileEditing
        
    }
    
}
