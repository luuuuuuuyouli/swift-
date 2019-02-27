//
//  GShareMenu.swift
//  Base
//
//  Created by daihz on 2019/2/1.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit

class GShareMenu: NSObject {

    class func showShareMenuView(title: String, descr: String, thumImage: UIImage, URL: String, uuidString: String, response: @escaping (() -> Void)) {
        UMSocialUIManager.showShareMenuViewInWindow { (platform, userInfo) in
            
            func sharePlatform(type:UMSocialPlatformType,
                               title:String,
                               descr:String,
                               thumImage:UIImage,
                               uuidString:String,
                               URL:String,
                               imageURL:String? = nil){
                let message =  UMSocialMessageObject()
                if type == .sina {
                    message.text = "\(title)\(URL)"
                    let imageObj = UMShareImageObject.shareObject(withTitle: title, descr: descr, thumImage: UIImage(named: "appDefaultIcon"))
                    imageObj?.shareImage = UIImage(named: "appDefaultIcon")
                    message.shareObject = imageObj
                }else if type.rawValue == 1001{
                    let pasteboard = UIPasteboard.general
                    pasteboard.string = URL
                    MBProgressHUD.showHUD(message: "复制成功")
                }else{
                    let webpage  = UMShareWebpageObject.shareObject(withTitle: title, descr: descr, thumImage: thumImage)
                    webpage?.webpageUrl = URL
                    message.shareObject = webpage
                }
                UMSocialManager.default().share(to: type, messageObject: message, currentViewController: self) { (_, _) in}
            }
            
            sharePlatform(type: platform, title: title, descr: descr, thumImage: thumImage, uuidString: uuidString, URL: URL)
            response()            
        }
    }
}
