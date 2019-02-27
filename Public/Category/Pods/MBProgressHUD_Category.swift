//
//  MBProgressHUD_Category.swift
//  ExerciseTool
//
//  Created by daihz on 2018/7/19.
//  Copyright © 2018年 daihz. All rights reserved.
//

import UIKit

extension MBProgressHUD{

    class func hideHUD() {
        guard let window = UIApplication.shared.keyWindow else {
            return 
        }
        MBProgressHUD.hide(for: window, animated: true)   
    }
    
    
    /// 展示弹窗 type(0 文本 , 1 菊花  , 2 进度条)
    @discardableResult
    class func showHUD(message: String, detailMessage: String? = nil, type: Int? = 0, view: UIView? = nil) -> MBProgressHUD? {
        guard let window = UIApplication.shared.keyWindow else {
            return  nil
        }
        hideHUD()
        let HUD = MBProgressHUD.showAdded(to: view ?? window, animated: true)
        HUD.label.text = message
        HUD.label.font = UIFont.systemFont(ofSize: 14)
        HUD.detailsLabel.text = detailMessage
        HUD.contentColor = .black
        if #available(iOS 10.0, *) {
            HUD.bezelView.style = .blur
        }
        HUD.removeFromSuperViewOnHide = true
        switch type {
        case 0:
            HUD.mode = .text
            HUD.hide(animated: true, afterDelay: 1.5)
        case 1:
            HUD.isSquare = message.count < 3 ? true : false
        case 2:
            HUD.mode = .determinateHorizontalBar
        default:break
        }
        return HUD
    }
    

}

