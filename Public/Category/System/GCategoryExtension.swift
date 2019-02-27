//
//  GCategoryExtension.swift
//  Base
//
//  Created by daihz on 2019/2/15.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit

extension String {
    
    /// 格式化时间字符串为时间
    ///
    /// - Parameter format: 格式
    /// - Returns: 格式化后时间
    func dateFormatDate(_ format: String) -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format 
        return dateFormat.date(from: self)
    }
}

extension Date {
    
    /// 格式化时间为字符串
    ///
    /// - Parameter format: 格式
    /// - Returns: 格式化后字符串
    func dateFormatString(_ format: String) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = format 
        return dateFormat.string(from: self)
    }
}

extension UIView {
    
    /// 角度处理
    ///
    /// - Parameters:
    ///   - radius: 角度半径
    ///   - cache: 是否缓存
    func cornerRadius(radius: CGFloat, cache: Bool = false) {
        self.layer.cornerRadius     = radius
        self.layer.masksToBounds    = true
        self.layer.shouldRasterize  = cache 
    }
    
    /// 阴影偏移处理  
    ///
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 偏移量
    func shadow(color: UIColor, offset: CGSize) {
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.masksToBounds = false
    }
    
    /// 角度和阴影共同处理   
    ///
    /// - Parameters:
    ///   - radius: 角度
    ///   - color: 阴影颜色
    ///   - offset: 偏移量
    ///   - layer: 底部layer，原理是给新加的layer添加阴影
    func cornerRadiusAndShadow(radius: CGFloat, color: UIColor, offset: CGSize, layer: CALayer? = nil) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        let subLayer = layer ?? CALayer()
        subLayer.frame = self.frame
        subLayer.cornerRadius = radius
        subLayer.backgroundColor = UIColor.white.cgColor
        subLayer.masksToBounds = false
        subLayer.shadowColor = color.cgColor
        subLayer.shadowOffset = offset
        subLayer.shadowOpacity = 0.3
        subLayer.shadowRadius = 4
        
        self.superview?.layer.insertSublayer(subLayer, below: self.layer)
    }

}

extension UIImage {
    /// 压缩图片大小
    ///
    /// - Parameter newSize: 转换后的图片大小
    /// - Returns: 转换后的图片
    func resizeImage(to newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let reSizeImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return reSizeImage ?? UIImage()
    }
    
    
    /// 压缩图片数据
    ///
    /// - Parameter m: 目标值，单位M
    /// - Returns: 返回压缩后的数据
    func dataResizeImage(_ m: Int) -> Data? {
        var compression: CGFloat = 1
        let maxCount = m * 1024 * 1024
        let tempData = jpegData(compressionQuality: compression)
        guard var data = tempData,data.count > maxCount else { 
            return tempData
        }
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            guard let newData =  jpegData(compressionQuality: compression) else {
                return data
            }
            data = newData
            if CGFloat(data.count) < CGFloat(maxCount) * 0.9 {
                min = compression
            } else if data.count > maxCount {
                max = compression
            } else {
                break
            }
        }
        return data
    }
}

extension UIButton {
    
    /// 0.图上文下  1.文左图右
    ///
    /// - Parameters:
    ///   - offset: 间距
    ///   - style: 样式
    func titleSpace(offset: Float, style: Int? = nil) {
        guard let aImageView = self.imageView,let aTitleLabel = self.titleLabel else {
            return
        }
        if style == nil || style == 0 {
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -aImageView.width, bottom: -aImageView.height - CGFloat(offset)/2, right: 0)
            self.imageEdgeInsets = UIEdgeInsets(top: -aTitleLabel.intrinsicContentSize.height - CGFloat(offset)/2, left: 0, bottom: 0, right: -aTitleLabel.intrinsicContentSize.width)
        }else{
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -aImageView.width - CGFloat(offset), bottom: 0, right: aImageView.width)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: aTitleLabel.intrinsicContentSize.width + CGFloat(offset), bottom: 0, right: -aTitleLabel.width - CGFloat(offset))
        }
        
    }
}
