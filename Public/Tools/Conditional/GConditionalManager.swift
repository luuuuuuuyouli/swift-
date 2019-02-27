//
//  GConditionalManager.swift
//  Base
//
//  Created by daihz on 2019/2/21.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit

class GConditionalManager: NSObject {

    
    /// 手机号合法判断
    ///
    /// - Parameter tel: 手机号字符串
    /// - Returns: 判断结果
    class func isTelphoneNumber(_ tel: String) -> Bool {
        return !tel.contains(" ") && tel.count == 11 && (tel as NSString).substring(with: NSMakeRange(0, 1)) == "1"
    }
    
    /// 邮箱合法判断
    ///
    /// - Parameter email: 邮箱字符串
    /// - Returns: 判断结果
    class func isEmail(_ email: String) -> Bool {
        let emailRegex = "\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) 
    }
}
