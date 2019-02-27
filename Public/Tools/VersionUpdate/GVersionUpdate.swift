//
//  GVersionUpdate.swift
//  Base
//
//  Created by daihz on 2019/2/14.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit
let itunesStoreID = 1447788732
class GVersionUpdate: NSObject {

    class func versionUpdate() {
        var appstoreVersion = 0
        GNetworkTool.post(URLString: "https://itunes.apple.com/cn/lookup?id=\(itunesStoreID)", parameters: nil) { (response, error) in
            arrayValue(response["results"]).forEach {
                appstoreVersion = convertRealVersion(version: stringValue(dictionaryValue($0)["version"]))                
            }
            let currentVersion = convertRealVersion(version: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "") 
            if currentVersion < appstoreVersion {
                let alert = UIAlertController(title: "您有新版本啦", message: "", preferredStyle: .alert)
                let update = UIAlertAction(title: "立即更新", style: .default, handler: { action in
                    if let url = URL(string: "https://itunes.apple.com/cn/app/id\(itunesStoreID)") {
                        //根据iOS系统版本，分别处理
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                })
                alert.addAction(update)
                let cancel = UIAlertAction(title: "取消", style: .cancel, handler:nil)
                alert.addAction(cancel)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
        func convertRealVersion(version: String)-> Int {
            var realVersion = ""
            for (i,obj) in version.components(separatedBy: ".").enumerated() {
                let appendInfo = i == 0 ? obj + "." : obj
                realVersion.append(appendInfo)
            }

            print("\(version):\(realVersion)")
            return Int(realVersion) ?? 0
        }
    }
}
