//
//  GSystemauthorizationManager.swift
//
//  Created by daihz on 2019/2/1.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Contacts
import Intents
import EventKit

// MARK: - PermissionState
class GSystemauthorizationManager: NSObject {

    /// 相机服务是否可用
    /// AVCaptureDevice.requestAccess(for: .video, completionHandler: <#T##(Bool) -> Void#>)
    /// - Returns: 可用或用户未选择
    class func isOpenCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .video)
        return authStatus != .restricted && authStatus != .denied
    }
    
    /// 麦克风权限是否可用
    /// AVCaptureDevice.requestAccess(for: .audio, completionHandler: <#T##(Bool) -> Void#>)
    /// - Parameter response: 可用或用户未选择
    class func isOpenAudioSession() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        return authStatus != .restricted && authStatus != .denied
    }  
        
    /// 相册服务是否可用
    /// PHPhotoLibrary.requestAuthorization(<#T##handler: (PHAuthorizationStatus) -> Void##(PHAuthorizationStatus) -> Void#>)
    /// - Returns: 可用或用户未选择
    class func isOpenPhoto() -> Bool {
        let authStatus = PHPhotoLibrary.authorizationStatus() 
        return authStatus != .restricted && authStatus != .denied
    }
        
    /// 位置服务是否可用
    /// CLLocationManager()  需要全局,ARC局部变量会被释放掉
    /// .requestAlwaysAuthorization()
    /// .requestWhenInUseAuthorization()
    /// - Returns: 可用或用户未选择
    class func isOpenLocation() -> Bool {
        return CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() != .denied
    }
    
    /// 蓝牙服务是否可用
    ///
    /// - Returns: 可用或用户未选择
    class func isOpenBluetooth() -> Bool {
        let authStatus = GCentralManager.shared.centralState
        return authStatus != .unsupported && authStatus != .unknown && authStatus != .poweredOff
    }
        
    /// 通讯录权限是否可用
    /// CNContactStore().requestAccess(for: .contacts, completionHandler: <#T##(Bool, Error?) -> Void#>)
    /// - Returns: 可用或用户未选择
    class func isOpenContacts() -> Bool {
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        return authStatus != .restricted && authStatus != .denied
    }
    
    /// 日历或备忘录服务是否可用
    /// EKEventStore().requestAccess(to: .event, completion: <#T##EKEventStoreRequestAccessCompletionHandler##EKEventStoreRequestAccessCompletionHandler##(Bool, Error?) -> Void#>)
    /// - Returns: 可用或用户未选择
    class func isOpenEventStore() -> Bool {
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        return authStatus != .restricted && authStatus != .denied
    }  
        
    @available(iOS 10.0, *)
    /// Siri服务是否可用
    /// INPreferences.requestSiriAuthorization(<#T##handler: (INSiriAuthorizationStatus) -> Void##(INSiriAuthorizationStatus) -> Void#>)
    /// - Returns: 可用或用户未选择
    class func isOpenSiriServer() -> Bool {
        let authStatus = INPreferences.siriAuthorizationStatus()
        return authStatus != .restricted && authStatus != .denied
    }
    
    class func isOpenPushNotification() -> Bool {
        let settingTypes = UIApplication.shared.currentUserNotificationSettings?.types
        return settingTypes?.rawValue == 0 
    }
    
}

