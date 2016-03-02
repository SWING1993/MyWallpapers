//
//  AppDelegate.swift
//  MyWallpaper
//
//  Created by 宋国华 on 16/1/20.
//  Copyright © 2016年 宋国华. All rights reserved.
//

import UIKit
import Material
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        customizeInterface()
        
        
        
        let firstVC = TodayController()
        firstVC.title = "Today"
        let firstNav = UINavigationController.init(rootViewController: firstVC)

        let secondVC = FeaturesController()
        secondVC.title = "Features"
        let secondNav = UINavigationController.init(rootViewController: secondVC)
        
        let thirdVC = CategoryController()
        thirdVC.title = "Category"
        let thirdNav = UINavigationController.init(rootViewController: thirdVC)

        let VCArr = [firstNav,secondNav,thirdNav]
        let tabBarController:UITabBarController = UITabBarController.init()
        tabBarController.viewControllers = VCArr;
        tabBarController.selectedIndex = 0
        
        let tabbar:UITabBar = tabBarController.tabBar
        let item1:UITabBarItem = tabbar.items![0]
        let item2:UITabBarItem = tabbar.items![1]
        let item3:UITabBarItem = tabbar.items![2]
        
        item1.image = UIImage.init(named: "TitleTab_0Normal")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item1.selectedImage = UIImage.init(named: "TitleTab_0")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item1.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        item1.title = ""

        item2.image = UIImage.init(named: "TitleTab_1Normal")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item2.selectedImage = UIImage.init(named: "TitleTab_1")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item2.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        item2.title = ""

        item3.image = UIImage.init(named: "TitleTab_3Normal")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item3.selectedImage = UIImage.init(named: "TitleTab_3")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        item3.imageInsets = UIEdgeInsets.init(top: 5, left: 0, bottom: -5, right: 0)
        item3.title = ""

        window!.rootViewController = tabBarController
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func customizeInterface() {
    
        let navigationBarAppearance : UINavigationBar = UINavigationBar.appearance()
        navigationBarAppearance.setBackgroundImage(NavigationBarColor(), forBarMetrics: UIBarMetrics.Default)
        let textAttributes:NSDictionary = [
            NSFontAttributeName:RobotoFont.mediumWithSize(17.0),
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
        navigationBarAppearance.titleTextAttributes = textAttributes as? [String : AnyObject]
        navigationBarAppearance.tintColor = UIColor.blackColor()
        navigationBarAppearance.barStyle = UIBarStyle.Default
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().backgroundImage = TabBarColor()
        
        UIBarButtonItem.appearance().tintColor = UIColor.blackColor()
        //去掉backBarButtonItem中的文字
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset.init(horizontal: 0, vertical: -60), forBarMetrics: UIBarMetrics.Default)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    func NavigationBarColor() ->UIImage {
        UIGraphicsBeginImageContext(CGRectMake(0, 0, 1, 1).size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, MaterialColor.white.CGColor)
        CGContextFillRect(context, CGRectMake(0, 0, 1, 1))
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    func TabBarColor() ->UIImage {
        UIGraphicsBeginImageContext(CGRectMake(0, 0, 1, 1).size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, MaterialColor.grey.darken4.CGColor)
        CGContextFillRect(context, CGRectMake(0, 0, 1, 1))
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

