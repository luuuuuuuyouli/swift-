//
//  GNetworkTool.swift
//  Base
//
//  Created by daihz on 2018/7/14.
//  Copyright © 2018年 daihz. All rights reserved.
//

import UIKit
import AFNetworking

///请求成功状态码
let successCode = "200"
let desStringKey   = "description"
let desStringValue   = "您当前的网络不稳定，请稍后重试。"

func getTimestamp()->String{
    
    return  String(NSDate().timeIntervalSince1970 * 1000)
}
typealias requestResponse = (_ response: NSDictionary, _ error: Error?) -> Void

class GNetworkTool: NSObject {

    // MARK: - Once
    static let shared = GNetworkTool()
        
    // MARK: - Private
    private var isLoginout = false
    private var isNetworking = true
    private var networkManager: AFHTTPSessionManager 
    
    private override init() {
        networkManager = AFHTTPSessionManager()
        networkManager.responseSerializer = AFJSONResponseSerializer()
        networkManager.requestSerializer  = AFJSONRequestSerializer()
        networkManager.responseSerializer.acceptableContentTypes = Set(["application/json",
                                                                  "text/html",
                                                                  "text/json",
                                                                  "text/plain",
                                                                  "text/javascript",
                                                                  "text/xml",
                                                                  "image/*"])
        networkManager.requestSerializer.timeoutInterval = 15
        networkManager.requestSerializer.setValue("Close", forHTTPHeaderField: "Connection")

    }
        
    /// 配置请求数据
    ///
    /// - Parameter type: 0. Json  1. 表单
    func setupAfNetworking(_ type: Int = 0) {
        
        let instance = GNetworkTool.shared.networkManager
        if type == 0 {
            instance.requestSerializer = AFJSONRequestSerializer() 
            instance.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type") 
        }else if type == 1{
            instance.requestSerializer = AFHTTPRequestSerializer()  
            instance.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type") 
        }
        
    }
    

    ///判断网络状态
     func setupReachability() {
        AFNetworkReachabilityManager.shared().startMonitoring()
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange { (status) in
            if status != .reachableViaWWAN && status != .reachableViaWiFi {
                printg("没有网")
                self.isNetworking = false
            }else{
                self.isNetworking = true
                printg("有网")
            }
        }
    }


    /// Post请求  
    ///
    /// - Parameters:
    ///   - URLString: 链接地址
    ///   - parameters: 请求参数
    ///   - response: 服务器返回结果
    class func post(URLString:String,parameters:Any?,response:@escaping requestResponse){

    let nt = GNetworkTool.shared
        if nt.isNetworking == false {
            response([desStringKey:desStringValue],nil)
            return
        }
        nt.setupAfNetworking()
        nt.networkManager.post(URLString, parameters: parameters, progress: nil, success: { (_, data) in
            
            if let res = data as? NSDictionary{
                response(res,nil)
            }else{
                response([desStringKey:desStringValue],nil)
            }
            
        }, failure: { (_, error) in
            response([desStringKey:desStringValue],error)
            printg("AFError\(error)")
        })
    }
    
    /// Get请求   
    ///
    /// - Parameters:
    ///   - URLString: 链接地址
    ///   - parameters: 请求参数
    ///   - response: 服务器返回结果
    class func get(URLString:String,parameters:Any?,response:@escaping requestResponse){
        let nt = GNetworkTool.shared
        if nt.isNetworking == false {
            response([desStringKey:desStringValue],nil)
            return
        }
        nt.setupAfNetworking()
        nt.networkManager.get(URLString, parameters: parameters, progress: nil, success: { (_, data) in
            if let res = data as? NSDictionary{
                response(res,nil)
            }else{
                response([desStringKey:desStringValue],nil)
            }
            
        }, failure: { (_, error) in
            response([desStringKey:desStringValue],error)
        })
    }
    
    /// Delete请求    
    ///
    /// - Parameters:
    ///   - URLString: 链接地址
    ///   - parameters: 请求参数
    ///   - response: 服务器返回结果
    class func delete(URLString:String,parameters:Any?,response:@escaping requestResponse){
        let nt = GNetworkTool.shared
        if nt.isNetworking == false {
            response([desStringKey:desStringValue],nil)
            return
        }
        nt.setupAfNetworking()
        nt.networkManager.delete(URLString, parameters: parameters, success: { (task, data) in
            if let res = data as? NSDictionary{
                response(res,nil)
            }else{
                response([desStringKey:desStringValue],nil)
            }
            
        }, failure: { (task, error) in
            response([desStringKey:desStringValue],error)
        })
    }
    
    /// Update请求
    ///
    /// - Parameters:
    ///   - URLString: 链接地址
    ///   - parameters: 请求参数
    ///   - response: 服务器返回结果
    class func update(URLString:String,parameters:Any?,response:@escaping requestResponse){
        let nt = GNetworkTool.shared

        if nt.isNetworking == false {
            response([desStringKey:desStringValue],nil)
            return
        }
        nt.setupAfNetworking()
        nt.networkManager.put(URLString, parameters: parameters, success: { (task, data) in
            if let res = data as? NSDictionary{
                response(res,nil)
            }else{
                response([desStringKey:desStringValue],nil)
            }
            
        }, failure: { (task, error) in
            response([desStringKey:desStringValue],error)

        })
    }
    
    /// 上传图片    
    ///
    /// - Parameters:
    ///   - URLString: 链接地址
    ///   - parameters: 请求参数
    ///   - images: 图片数组
    ///   - names: 图片数组对应的字段名字(服务器定义)
    ///   - response: 服务器返回结果
    class func uploadImage(URLString:String,parameters:Any?,images:[UIImage],names:[String],response:@escaping requestResponse){
        let nt = GNetworkTool.shared
        if nt.isNetworking == false {
            response([desStringKey:desStringValue],nil)
            return
        }
        nt.setupAfNetworking(1)
        nt.networkManager.post(URLString, parameters: parameters, constructingBodyWith: { (formData) in
            for (index,object) in images.enumerated() {
                if let imageData = object.dataResizeImage(3) {
                    let imageName = names.count > index ? names[index] : "imageName\(index)"
                    formData.appendPart(withFileData: imageData, name: imageName, fileName: imageName + ".jpg", mimeType: "image/jpg")  
                }
            }
        }, progress: nil, success: { (_,data) in
            if let res = data as? NSDictionary{
                response(res,nil)
            }else{
                response([desStringKey:desStringValue],nil)
            }
        }) { (_, error) in
            response([desStringKey:desStringValue],error)
        }
    }
    
}
