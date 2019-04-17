//
//  SKPaddingLabel.swift
//  SKPaddingLabel
//
//  Created by 清水 脩輔 on 2019/04/16.
//  Copyright © 2019 清水 脩輔. All rights reserved.
//

import UIKit

@IBDesignable
open class SKPaddingLabel: UILabel {
    // padding
    open var padding: UIEdgeInsets = UIEdgeInsets.zero
    
    // 上下左右のpaddingを設定する
    @IBInspectable var topPadding: CGFloat = 0.0 {
        didSet {
            self.padding.top = self.topPadding
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0.0 {
        didSet {
            self.padding.left = self.leftPadding
        }
    }
    @IBInspectable var bottomPadding: CGFloat = 0.0 {
        didSet {
            self.padding.bottom = self.bottomPadding
        }
    }
    @IBInspectable var rightPadding: CGFloat = 0.0 {
        didSet {
            self.padding.right = self.rightPadding
        }
    }
    
    override open func drawText(in rect: CGRect) {
        let newRect = rect.inset(by: self.padding)
        self.layoutIfNeeded()
        super.drawText(in: newRect)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override open var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += self.padding.top + self.padding.bottom
        contentSize.width += self.padding.left + self.padding.right
        return contentSize
    }
}
