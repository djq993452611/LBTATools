//
//  UIButton+Extension.swift
//  SeaKitchen
//
//

import UIKit

public extension UIButton {
    //只有文字
    convenience init(onlyTitle: String, titleColor: UIColor, font: UIFont, backgroundColor: UIColor? = .clear){
        self.init(frame: .zero)
        self.setTitle(onlyTitle, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.backgroundColor = backgroundColor
    }
    
    //只有图片
    convenience init(onlyImage: UIImage?, alignmentH: ContentHorizontalAlignment? = .left, alignmentV: ContentVerticalAlignment? = .center, backgroundColor: UIColor? = .clear) {
        self.init(frame: .zero)
        self.setImage(onlyImage, for: .normal)
        self.contentHorizontalAlignment = alignmentH ?? .left
        self.contentVerticalAlignment = alignmentV ?? .center
        self.backgroundColor = backgroundColor
    }
    
    //图文都有
    convenience init(title: String, titleColor: UIColor, font: UIFont, image: UIImage?, alignmentH: ContentHorizontalAlignment? = .left, alignmentV: ContentVerticalAlignment? = .center, backgroundColor: UIColor? = .clear){
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = font
        self.setImage(image, for: .normal)
        self.contentHorizontalAlignment = alignmentH ?? .left
        self.contentVerticalAlignment = alignmentV ?? .center
        self.backgroundColor = backgroundColor
    }
    
}



