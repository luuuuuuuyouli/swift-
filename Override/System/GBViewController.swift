//
//  GBViewController.swift
//  Base
//
//  Created by daihz on 2018/6/12.
//  Copyright © 2018年 daihz. All rights reserved.
//

import UIKit

enum BackgroundImageStyle: Int {
    case fill = 0
    case `default`
}

class GBViewController: UIViewController {
    
    ///自动隐藏栈底视图的导航栏
    var isAutoHideNavigation = true 
    
    /// 导航栏左按钮
    var leftBarButtonItem: UIButton?
    
    /// 导航栏右按钮
    var rightBarButtonItem: UIButton?
    
    /// 设置导航栏透明，默认不透明
    var isNavigationClear = false {
        didSet{
            guard let navigation = navigationController else {
                return
            }
            if isNavigationClear == true {
                navigation.navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigation.navigationBar.isTranslucent = true
            }else {
                navigation.navigationBar.setBackgroundImage(nil, for: .default)
                navigation.navigationBar.barTintColor = defaultColor
            }
        }
    }
    
    /// 导航栏左按钮标题
    var leftBarItemTitle: NSAttributedString! {
        didSet{
            if leftBarButtonItem == nil {
                self.navigationItem.leftBarButtonItem = creatLeftBarItem()
            }else {
                leftBarButtonItem?.setAttributedTitle(leftBarItemTitle, for: .normal)
            }
        }
    }
    
    /// 导航栏右按钮标题
    var rightBarItemTitle: NSAttributedString! {
        didSet{
            if rightBarButtonItem == nil {
                self.navigationItem.rightBarButtonItem = creatRightBarItem()
            }else {
                rightBarButtonItem?.setAttributedTitle(rightBarItemTitle, for: .normal)
            }
        }
    }
    
    /// 右滑返回状态
    var popGestureEnable: Bool = true {
        didSet{
            guard let popGestureRecognizer = navigationController?.interactivePopGestureRecognizer else {
                return
            }
            popGestureRecognizer.isEnabled = popGestureEnable
            popGestureRecognizer.delegate = self
        }
    }
    
    /// 左按钮图片
    var leftBarItemImage: UIImage? {
        didSet{
            if self.leftBarButtonItem == nil {
                self.navigationItem.leftBarButtonItem = creatLeftBarItem()
            }else {
                self.leftBarButtonItem?.setImage(leftBarItemImage, for: .normal)
            }
        }
    }
    
    /// 右按钮图片
    var rightBarItemImage: UIImage? {
        didSet{
            if rightBarButtonItem == nil {
                self.navigationItem.rightBarButtonItem = creatRightBarItem()
            }else {
                rightBarButtonItem?.setImage(rightBarItemImage, for: .normal)
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = defaultColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigation()
    }
    
    /// 设置背景图片  
    ///
    /// - Parameters:
    ///   - image: 新背景图片
    ///   - type: 填充类型，默认不包含导航栏
    func setBackgroundImage(image: UIImage, style: BackgroundImageStyle = .default) {
        isNavigationClear = true
        let backImageView = UIImageView(image: image)
        backImageView.frame = style == .fill ? CGRect(x: 0, y: -NAV_HEIGHT(), width: self.view.bounds.size.width, height: self.view.bounds.size.height) : self.view.bounds
        self.view.insertSubview(backImageView, at: 0)
    }    
    
    private  func configNavigation() {
        //没有导航栏就退出操作
        guard let navigation = self.navigationController else {
            return
        }
        //默认禁止半透明
        navigation.navigationBar.isTranslucent = true
        navigation.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]
        navigation.navigationBar.shadowImage = UIImage()
        guard isAutoHideNavigation == true else {
            return
        }
        //设置导航栏item
        if navigation.viewControllers.count > 1 {
            if self.navigationItem.leftBarButtonItem == nil {
              self.navigationItem.leftBarButtonItem = creatLeftBarItem()
            }
        }
    }
    
    
     //MARK:---- InitUI
    
    /// 创建导航栏左按钮
    ///
    /// - Returns: 导航栏左按钮
    private func creatLeftBarItem() -> UIBarButtonItem? {
        if let lbi = leftBarButtonItem {
            return UIBarButtonItem(customView: lbi)
        }
        leftBarButtonItem = UIButton(type: .custom)
        leftBarButtonItem!.frame = CGRect(x: 0, y: 0, width: WIDTH_CONSTARIN(width: 44), height: 44)
        if let lbii = leftBarItemImage { leftBarItemImage = lbii.resizeImage(to: CGSize(width: 20, height: 20)) }
        leftBarButtonItem!.setImage((leftBarItemImage != nil) ? leftBarItemImage : UIImage(named: "return_write"), for: .normal)
        leftBarButtonItem!.setAttributedTitle(leftBarItemTitle, for: .normal)
        leftBarButtonItem!.addTarget(self, action: #selector(NavigationBarButtonItemClicked(sender:)), for: .touchUpInside)
        leftBarButtonItem!.tag = 10000
        leftBarButtonItem!.imageView?.contentMode = .scaleAspectFit
//        leftBarButtonItem!.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20) 
        return UIBarButtonItem(customView: leftBarButtonItem!)
    }
    
    /// 创建导航栏右按钮
    ///
    /// - Returns: 导航栏右按钮
    func creatRightBarItem() -> UIBarButtonItem? {
        if let rbi = rightBarButtonItem {
            return UIBarButtonItem(customView: rbi)
        }
        rightBarButtonItem = UIButton()
        rightBarButtonItem!.tag = 10001
        rightBarButtonItem!.frame = CGRect(x: 0, y: 0, width: WIDTH_CONSTARIN(width: 44), height: 44)
        if rightBarItemImage != nil { rightBarButtonItem!.setImage(rightBarItemImage, for: .normal) }
        if rightBarItemTitle != nil { rightBarButtonItem!.setAttributedTitle(rightBarItemTitle, for: .normal) }
        rightBarButtonItem!.addTarget(self, action: #selector(NavigationBarButtonItemClicked(sender:)), for: .touchUpInside)
        return UIBarButtonItem(customView: rightBarButtonItem!)
    }
    
     //MARK:---- actions
    /// 导航栏按钮点击事件
    ///
    /// - Parameter sender: 点击的按钮
    @objc func NavigationBarButtonItemClicked(sender: UIButton) {
        if sender.tag ==  10000{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        printg("--------------------\(self)--------------------")
    }
}

extension GBViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKind(of: UIScreenEdgePanGestureRecognizer.self) {
            return (self.navigationController?.viewControllers.count)! > 1 ? true : false
        }
        return true
    }
}

