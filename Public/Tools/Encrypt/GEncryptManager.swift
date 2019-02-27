//
//  GEncryptManager.swift
//  Base
//
//  Created by daihz on 2019/2/21.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    
    /// MD5加密
    ///
    /// - Returns: MD5加密后的字符串
    func MD5() -> String {
        let cStr = cString(using: String.Encoding.utf8)
        let strLength = CUnsignedInt(lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        CC_MD5(cStr!, strLength, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLength {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return hash as String
    }
}
