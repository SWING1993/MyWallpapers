//
//  Define.swift
//  MyWallpaper
//
//  Created by 宋国华 on 16/2/27.
//  Copyright © 2016年 宋国华. All rights reserved.
//

import Foundation

class Define: NSObject {
    
    //iPhone的屏幕的物理高度
    class func screenHeight() ->CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
    
    //iPhone的屏幕的物理宽度
    class func screenWidth() ->CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    //iPhone的屏幕的ScreenBounds
    class func screenBounds() ->CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    //iPhone的屏幕的ScreenFrame
    class func screenFrame() ->CGRect {
        return UIScreen.mainScreen().applicationFrame
    }

    //iPhone的屏幕的ScreenSize
    class func screenSize() ->CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    //是否为3.5寸的iPhone
    class func isiPhone4x_3_5() ->Bool {
        return UIScreen.mainScreen().bounds.height == 480 ? true : false
    }
    
    //是否为4.0寸的iPhone
    class func iphone5x_4_0() ->Bool {
        return UIScreen.mainScreen().bounds.height == 568 ? true : false
    }
    
    //是否为4.7寸的iPhone
    class func iphone6_4_7() ->Bool {
        return UIScreen.mainScreen().bounds.height == 667 ? true : false
    }
    
    //是否为5.5寸的iPhone
    class func iphone6Plus_5_5() ->Bool {
        return UIScreen.mainScreen().bounds.height == 736 ? true : false
    }
    
    
}
