//
//  GAnimationManager.swift
//  Base
//
//  Created by daihz on 2019/2/22.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit

class GAnimationManager: NSObject {

    /// 转场动画    
    ///
    /// - Parameters:
    ///   - view: 展示动画的View
    ///   - duration: 动画时间
    class func transitionAnimated(view:UIView,duration:CFTimeInterval?=nil){
        let animation = CATransition()
        animation.duration = duration ?? 0.618
        animation.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
        animation.type = CATransitionType(rawValue: "fade")
        animation.subtype = nil
        view.layer.add(animation, forKey: nil)
    }
}
