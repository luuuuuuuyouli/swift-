//
//  GLocationNotificationManager.swift
//  Base
//
//  Created by daihz on 2019/2/15.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit
import UserNotifications

 var iconBadgeNumber = 0

class GLocationNotificationManager: NSObject {
    @available(iOS 10.0, *)
    class func registNotification(_ delegate: UNUserNotificationCenterDelegate?) {
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (res, error) in

        }
    }
    
    class func registNotification() {
        let userSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(userSettings)
    }
    
    class func pushLocalNotificatio(send body: String, title: String, soundName: String? = nil, userInfo: [String:Any]? = nil)  {
        if #available(iOS 10.0, *) {
            let content = UNMutableNotificationContent()
            content.body = body
            content.title = title
            iconBadgeNumber += 1
            content.badge = iconBadgeNumber as NSNumber
            //设置通知触发器
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.01, repeats: false)
            
//            let sound = soundName == nil ? nil : 
            //设置请求标识符
            if let sn = soundName  {
                content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: sn))
            }else {
                content.sound = nil
            }
            let requestIdentifier = "SwUserNotification" + body
            if userInfo != nil{
                content.userInfo = userInfo!
            }
            //设置一个通知请求
            let request = UNNotificationRequest(identifier: requestIdentifier,
                                                content: content, trigger: trigger)
            //将通知请求添加到发送中心
            UNUserNotificationCenter.current().add(request) { error in

            }
            
        }else {
            //创建UILocalNotification来进行本地消息通知
            let localNotification = UILocalNotification()
            //推送时间 当前
            localNotification.timeZone = NSTimeZone.default
            //推送内容
            localNotification.alertBody =  body
            localNotification.soundName = soundName
            localNotification.applicationIconBadgeNumber = iconBadgeNumber
            //额外信息
            UIApplication.shared.scheduleLocalNotification(localNotification)
        }
    }
}
