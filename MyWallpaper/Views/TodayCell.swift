//
//  TodayCell.swift
//  MyWallpaper
//
//  Created by 宋国华 on 16/2/23.
//  Copyright © 2016年 宋国华. All rights reserved.
//

import UIKit
import Material

class TodayCell: MaterialTableViewCell {

//    private let cellHeight:CGFloat = UIScreen.mainScreen().bounds.height/3
    
    var contentLabel:UILabel!
    var pictrueView:UIImageView!
    var cellLine:UIView!
    
    private let pictrueWidth:CGFloat = (UIScreen.mainScreen().bounds.size.width - 60)/2
    private let pictrueHeight:CGFloat = (UIScreen.mainScreen().bounds.size.width - 60)*2/3
    private let labelWidth:CGFloat = UIScreen.mainScreen().bounds.size.width - (UIScreen.mainScreen().bounds.size.width - 60)/2 - 60
    private let cellHeight:CGFloat = UIScreen.mainScreen().bounds.height/3
  

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if contentLabel == nil {
            contentLabel = UILabel.init()
            contentLabel.numberOfLines = 0
            contentLabel.font = RobotoFont.lightWithSize(14.0)
            contentLabel.textColor = UIColor.blackColor()
            self.addSubview(contentLabel!)
            contentLabel!.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromTopLeft(self, child: contentLabel!, top: 5, left: 20)
            MaterialLayout.size(self, child: contentLabel!, width: labelWidth, height: pictrueHeight)
        }
        
        if pictrueView == nil {
            pictrueView = UIImageView.init()
            pictrueView.contentMode = UIViewContentMode.ScaleAspectFill
            pictrueView.clipsToBounds = true
            self.addSubview(pictrueView)
            pictrueView!.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromTopLeft(self, child: pictrueView, top: 5, left: 40 + labelWidth)
            MaterialLayout.size(self, child: pictrueView, width: pictrueWidth, height: pictrueHeight)
        }
        if cellLine == nil {
            cellLine = UIView.init()
            cellLine.backgroundColor = MaterialColor.grey.base
            self.addSubview(cellLine)
            cellLine.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromTopLeft(self, child: cellLine, top: cellHeight-1, left: 20 )
            MaterialLayout.size(self, child: cellLine, width: Define.screenWidth()-20, height: 0.5)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
 

}
