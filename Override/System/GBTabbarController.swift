//
//  GBTabbarController.swift
//  Base
//
//  Created by daihz on 2018/8/4.
//  Copyright © 2018年 daihz. All rights reserved.
//

import UIKit

class GBaseNavigationController: UINavigationController{
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

class GBTabbarController: UITabBarController ,UITabBarControllerDelegate {

    var controllers: [UIViewController]!
    var normalImages: [String]!
    var selectImages: [String]!
    var nomarlTextColor: UIColor?
    var selectTextColor: UIColor?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let deviceLocationController  = MHDevicesLocationViewController()
        let deviceListController  = MHDeviceListViewController()
        let circleController = MHCircleViewController()
        let usercenterController = MHUserCenterViewController()
        deviceLocationController.title = "位置"
        deviceListController.title = "设备"
        circleController.title = "圈子"
        usercenterController.title = "我的" 
//        deviceLocationController.tabBarItem.title = "位置"
//        deviceListController.tabBarItem.title = "设备"
//        circleController.tabBarItem.title = "圈子"
//        usercenterController.tabBarItem.title = "我的" 
//        deviceLocationController.navigationItem.title = "蜂眼云"
//        deviceListController.navigationItem.title = "用户管理"
//        circleController.navigationItem.title = nil
//        usercenterController.navigationItem.title = nil
        controllers  = [deviceLocationController,deviceListController,circleController,usercenterController]
        normalImages = ["tabbar_location_n","tabbar_device_n","tabbar_circle_n","tabbar_user_n"]
        selectImages = ["tabbar_location_s","tabbar_device_s","tabbar_circle_s","tabbar_user_s"]
        loadControllers()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: defaultColor], for: .selected)
    }
    
    func loadControllers() {
        for (index,controller) in controllers.enumerated() {
            let normalImage = normalImages.count > index ? UIImage(named: normalImages[index])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal) : nil
            let selectImage = selectImages.count > index ? UIImage(named: selectImages[index])?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal) : nil
            initChildControllers(controller: controller, normalImage: normalImage, selectImage: selectImage)
        }
    }

    private func initChildControllers(controller: UIViewController, normalImage: UIImage?, selectImage: UIImage?) {
        controller.tabBarItem.image = normalImage
        controller.tabBarItem.selectedImage = selectImage
        addChild(GBaseNavigationController(rootViewController: controller))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
//        clearCache(path: tempPath)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if (viewController.tabBarItem.title == "用户" ||
//            viewController.tabBarItem.title == "设备" ||
//            viewController.tabBarItem.title == "我的" ) {
//            if AccountManager.readAccountModel().access_token == nil || AccountManager.readAccountModel().access_token == ""{
//                self.present(UINavigationController.init(rootViewController: LoginViewController()), animated: true, completion: nil)
//                return false
//            }
//        }
//        
        return true
    }

}
