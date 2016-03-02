//
//  FeatureModel.swift
//  MyWallpaper
//
//  Created by 宋国华 on 16/1/27.
//  Copyright © 2016年 宋国华. All rights reserved.
//

import UIKit

class FeatureModel: NSObject {

    var guid = NSNumber()
    var type = NSNumber()
    var title = String()
    var thumb = String()
    var thumb_hd = String()
    var cover = String()
    var cover_hd = String()
    var cover_hd_568h = String()
    var pubdate = String()
    var archive_timestamp = NSNumber()
    var timestamp = NSNumber()
    var summary = String()
    var content = String()
    var photo_count = NSNumber()
    
    var album = NSArray()
}
