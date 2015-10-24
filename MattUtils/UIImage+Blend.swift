//
//  UIImage+Blend.swift
//  MattUtils
//
//  Created by Matthew Buckley on 10/22/15.
//  Copyright © 2015 Matt Buckley. All rights reserved.
//

import Foundation

extension UIImage {

    // Returns a blended UIImage blended over the specified color
    func blend(blendMode blendMode: CGBlendMode, color: CGColor, alpha: CGFloat) -> UIImage {

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()

        // fill background with specified color
        CGContextSetFillColorWithColor(context, color)
        CGContextFillRect(context, rect)

        drawInRect(rect, blendMode: blendMode, alpha: alpha)

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }

}
