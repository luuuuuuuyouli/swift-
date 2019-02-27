//
//  GCountdownButton.swift
//  Base
//
//  Created by daihz on 2018/7/19.
//  Copyright © 2018年 daihz. All rights reserved.
//

import UIKit

class GCountdownButton: UIButton {

    /// 倒计时时间(秒)
    var timeCount = 60
    /// 倒计时附加文字
    var appending: Any!

    var isRunning = false
    private var timer: Timer?
    private var cacheCount: Int = 0
    private var cacheTitle: String?
    
    /// 开始倒计时
    func countdownStart() {
        self.isUserInteractionEnabled = false
        self.titleLabel?.textAlignment = .center
        cacheTitle = self.titleLabel?.text
        cacheCount = timeCount
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(beginCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func beginCountdown() {
        cacheCount -= 1
        self.titleLabel?.text = "\(cacheCount)\(appending ?? "")"
        isRunning = true
        if cacheCount <= 0 {
            isRunning = false
            timer?.invalidate()
            timer = nil
            cacheCount = timeCount
            self.titleLabel?.text = cacheTitle
            self.isUserInteractionEnabled = true
        }
    }

}
