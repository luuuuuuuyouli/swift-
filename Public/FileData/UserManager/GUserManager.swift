//
//  GUserManager.swift
//  Base
//
//  Created by daihz on 2019/2/14.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit

let userAccountPath = documentsPath + "/accountInfo.data"

class GUserManager: NSObject {

    @discardableResult
    class func saveUser(model: GUserModel) -> Bool {
       return NSKeyedArchiver.archiveRootObject(model, toFile: userAccountPath)
    }
    
    class func loadUsertModel() -> GUserModel {
        return NSKeyedUnarchiver.unarchiveObject(withFile: userAccountPath) as? GUserModel ?? GUserModel.shared
    }
}

class GUserModel: NSObject, NSCoding {
    
    static let shared = GUserModel()
    
    var token: String?
    
    private override init() {
        super.init()
    }
    
    // MARK: - Coding
    required init?(coder aDecoder: NSCoder) {
        super.init()
      token = aDecoder.decodeObject(forKey: "token") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(token, forKey: "token")
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}

func getIvarNames(_ typeClass: AnyClass) -> [String] {
    
    var count: UInt32 = 0
    let ivars = class_copyIvarList(typeClass, &count)!
    var names = [String]()
    for i in 0..<count {
        let ivar = ivars[Int(i)]
        guard  let name = ivar_getName(ivar) else {
            return []
        }
        names.append(String(cString: name))
    }
    free(ivars)
    return names

}

/*************************************************************************************
 // MARK: - Coding
 required init?(coder aDecoder: NSCoder) {
 super.init()
 for property in getIvarNames(GUserModel.self) {
 let NSProperty = property as NSString
 //修改首字母为大写
 let firstUppercased = NSProperty.substring(with: NSMakeRange(0, 1)).uppercased()
 let setMethodName = "set\(firstUppercased)\(NSProperty.substring(from: 1)):" 
 //            if responds(to: NSSelectorFromString(setMethodName)) {
 perform(NSSelectorFromString(setMethodName), with: aDecoder.decodeObject(forKey: property))
 //            }
 }
 }
 
 func encode(with aCoder: NSCoder) {
 for property in getIvarNames(GUserModel.self) {
 //            if responds(to: NSSelectorFromString(property)) {
 aCoder.encode(perform(NSSelectorFromString(property)), forKey: property)
 //            }
 }
 }
***************************************************************************************/

