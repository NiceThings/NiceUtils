//
//  UIWindow+Screenshot.swift
//  MattUtils
//
//  Created by Matthew Buckley on 10/21/15.
//  Copyright © 2015 Matt Buckley. All rights reserved.
//

import Foundation

extension UIWindow {

    class func screenShot() -> UIImage {

        let orientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        let imageSize: CGSize = UIInterfaceOrientationIsPortrait(orientation) ? UIScreen.mainScreen().bounds.size : CGSizeMake(UIScreen.mainScreen().bounds.size.height, UIScreen.mainScreen().bounds.size.width)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
        let context: CGContextRef? = UIGraphicsGetCurrentContext()

        if let context = context {
            for window in UIApplication.sharedApplication().windows {
                CGContextSaveGState(context)
                CGContextTranslateCTM(context, window.center.x, window.center.y)
                CGContextConcatCTM(context, window.transform)
                CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y)

                let pi_2: CGFloat = CGFloat(M_PI_2)
                let pi: CGFloat = CGFloat(M_PI)
                
                switch (orientation) {
                    case UIInterfaceOrientation.LandscapeLeft:
                        CGContextRotateCTM(context, pi_2)
                        CGContextTranslateCTM(context, 0, -imageSize.width)
                        break
                    case UIInterfaceOrientation.LandscapeRight:
                        CGContextRotateCTM(context, -pi_2)
                        CGContextTranslateCTM(context, -imageSize.height, 0)
                        break
                    case UIInterfaceOrientation.PortraitUpsideDown:
                        CGContextRotateCTM(context, pi)
                        CGContextTranslateCTM(context, -imageSize.width, -imageSize.height)
                        break
                    default:
                        break
                }

                if (window.respondsToSelector(Selector("drawViewHierarchyInRect:"))) {
                    window.drawViewHierarchyInRect(window.bounds, afterScreenUpdates: true)
                }
                else {
                    window.layer.renderInContext(context)
                }
                CGContextRestoreGState(context)
            }
        }
        else {
            print("unable to get current graphics context")
        }

        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }

}
