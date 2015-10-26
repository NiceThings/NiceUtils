//
//  HairlineView.swift
//  MattUtils
//
//  Created by Matthew Buckley on 10/24/15.
//  Copyright © 2015 Matt Buckley. All rights reserved.
//

import UIKit

class HairlineView: UIView {

    @IBInspectable var horizontal: Bool = true
    @IBInspectable var lineWidth: CGFloat = 1.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() -> Void {
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()

        // Default to red background color
        backgroundColor = .redColor()
    }

    override func intrinsicContentSize() -> CGSize {
        var size: CGSize = CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric)

        if horizontal {
            size.height = lineWidth
        }
        else {
            size.width = lineWidth
        }
        
        return size
    }
    
}
