//
//  GAudioPlayerManager.swift
//  Base
//
//  Created by daihz on 2019/2/14.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class GAudioPlayerManager: NSObject {
    
    /// 播放器
    var player: AVAudioPlayer?
    
    /// 播放器音量
    var volume: Float = 0.0
    
    /// 播放循环次数，默认循环播放
    var numberOfLoops = -1 
    
    /// 播放时间，默认15s
    var playTime = 15.0
    
    var playFinishBlock: (() -> Void)?
    
    // MARK: - Private
    private var timer: Timer?
    private var sysSlider: UISlider!
    private var playCategory: AVAudioSession.Category!
    private var isSuccess = false
    
    static let shared = GAudioPlayerManager()
    
    private override init() {
        super.init()
        sysSlider = systemSlider()
        sysSlider.frame =  CGRect(x: -300, y: -300, width: 0, height: 0)
        volume = AVAudioSession.sharedInstance().outputVolume 
        NotificationCenter.default.addObserver(self, selector: #selector(self.volumeChanged), name: NSNotification.Name(rawValue: "AVSystemController_SystemVolumeDidChangeNotification"), object: nil)
    }
    
    /// 获取系统音量控件
    ///
    /// - Returns: 系统音量控件
    func systemSlider() -> UISlider {
        let volView = MPVolumeView(frame: CGRect(x: -300, y: -300, width: 0, height: 0))
        for view in volView.subviews {
            if view.classForCoder.description() == "MPVolumeSlider"{
                return view as! UISlider 
            }
        }
        return UISlider()
    }
    
    // MARK: - Action
    
    /// 获取播放状态
    ///
    /// - Returns: 返回是否正在播放
    func isPlaying() -> Bool {
        return player?.isPlaying ?? false
    }
    
    /// 监听系统音量改变通知，进行纠偏
    ///
    /// - Parameter notifi: 系统音量改变通知
    @objc func volumeChanged(notifi: NSNotification) {
        if let volum: Float = notifi.userInfo?["AVSystemController_AudioVolumeNotificationParameter"] as? Float{
            if volum != 1.0 || isPlaying() != true{
                volume = volum
            }
        }
    }
    
    /// 加载音频文件路径并播放 
    ///
    /// - Parameters:
    ///   - urlString: 音频文件路径
    ///   - category: 音频播放类别，默认后台播放
    ///   - autoplay: 是否自动播放，默认自动播放
    func loadAudioFile(urlString: String, category: AVAudioSession.Category = .playback, autoplay: Bool = true) {
        playCategory = category
        stop()
        do {
            guard let resourcePath = Bundle.main.path(forResource: urlString, ofType: nil), let data = FileManager.default.contents(atPath: resourcePath) else {
                return
            }
            player = try AVAudioPlayer(data: data)
            player?.volume = 1.0
            player?.delegate = self
            player?.numberOfLoops   = numberOfLoops

        } catch  {
            
        }
        if autoplay { play() }
    }
    
    /// 重置定时器
    func resetTimer(){
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(playTime), target: self, selector: #selector(playFinish), userInfo: nil, repeats: false)
    }
    
    /// 开始播放
    func play() {
       UIApplication.shared.keyWindow?.addSubview(sysSlider)
        guard let currentPlayer = player else {
            return
        }
        sysSlider.setValue(1.0, animated: false)
        resetTimer()
        isSuccess = currentPlayer.play()
    }
    
    /// 暂停
    func pause() {
        guard let currentPlayer = player else {
            return
        }
        currentPlayer.pause()
        sysSlider.value = volume
        timer?.invalidate()
    }
    
    /// 停止播放
    func stop() {
        guard let currentPlayer = player else {
            return
        }
        currentPlayer.stop()
        sysSlider.value = volume
        timer?.invalidate()
    }
    
    /// 播放完成
    @objc func playFinish(){
        stop()
    }
}

extension GAudioPlayerManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playFinishBlock?()
        stop()
    }
}
