//
//  TypeCast.swift
//  CPAlertViewController
//
//  Created by ZhaoWei on 15/12/8.
//  Copyright © 2015年 CP3HNU. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var f: CGFloat { return CGFloat(self) }
}

extension Float {
    var f: CGFloat { return CGFloat(self) }
}

extension Double {
    var f: CGFloat { return CGFloat(self) }
}

extension CGFloat {
    var swf: Float { return Float(self) }
}

open class CPAdaptiveTextView : UITextView {
    
    var fixedWidth: CGFloat = 0.0
    override open var intrinsicContentSize : CGSize {
        
        if self.text == nil || self.text.isEmpty {
            return CGSize(width: fixedWidth, height: 0)
        }
        
        let text: NSString = self.text as NSString
        let font = self.font ?? UIFont.systemFont(ofSize: CPAlertViewController.messageFontSize)
        
        let rect = text.boundingRect(with: CGSize(width: fixedWidth - 2 * self.textContainer.lineFragmentPadding, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        let vPadding = self.textContainerInset.top + self.textContainerInset.bottom
        let size = CGSize(width: ceilf(rect.size.width.swf).f, height: ceilf(rect.size.height.swf).f + vPadding)
        
        return size
    }
}

extension UIColor {
    convenience init(rgbValue: UInt, alpha: Float = 1.0) {
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    func image() -> UIImage {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
