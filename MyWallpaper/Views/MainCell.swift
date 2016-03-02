//
//  MainCell.swift
//  MyWallpaper
//
//  Created by 宋国华 on 16/1/27.
//  Copyright © 2016年 宋国华. All rights reserved.
//

import UIKit
import Material

class MainCell: MaterialTableViewCell {
    
    
    private let cellHeight:CGFloat = UIScreen.mainScreen().bounds.height/3
    private let pictrueWidth:CGFloat = (UIScreen.mainScreen().bounds.size.width - 60)/3
    private let pictrueHeight:CGFloat = (UIScreen.mainScreen().bounds.size.width - 60)*4/9

    private let jianxi:CGFloat = 20/3

    var cellDetailTextLabel2: UILabel?
    var cellImageView1: UIImageView?
    var cellImageView2: UIImageView?
    var cellImageView3: UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
        if cellImageView1 == nil {
            cellImageView1 = UIImageView.init()
            cellImageView1!.contentMode = UIViewContentMode.ScaleAspectFill
            cellImageView1!.clipsToBounds = true
            self.addSubview(cellImageView1!)
            cellImageView1!.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromTopLeft(self, child: cellImageView1!, top: 0, left: 20)
            MaterialLayout.size(self, child: cellImageView1!, width: pictrueWidth, height: pictrueHeight)
        }
        
        if cellImageView2 == nil {
            cellImageView2 = UIImageView.init()
            cellImageView2!.contentMode = UIViewContentMode.ScaleAspectFill
            cellImageView2!.clipsToBounds = true
            self.addSubview(cellImageView2!)
            cellImageView2!.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromTopLeft(self, child: cellImageView2!, top: 0, left: 20 + pictrueWidth + jianxi)
            MaterialLayout.size(self, child: cellImageView2!, width: pictrueWidth, height: pictrueHeight)
        }
        
        if cellImageView3 == nil {
            cellImageView3 = UIImageView.init()
            cellImageView3!.contentMode = UIViewContentMode.ScaleAspectFill
            cellImageView3!.clipsToBounds = true
            self.addSubview(cellImageView3!)
            cellImageView3!.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromTopRight(self, child: cellImageView3!, top: 0, right: 20)
            MaterialLayout.size(self, child: cellImageView3!, width: pictrueWidth, height: pictrueHeight)
        }

        if cellDetailTextLabel2 == nil {
            cellDetailTextLabel2 = UILabel.init()
            cellDetailTextLabel2?.numberOfLines = 0
            cellDetailTextLabel2?.font = RobotoFont.thinWithSize(13.0)
            self.addSubview(cellDetailTextLabel2!)
            cellDetailTextLabel2!.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromTopLeft(self, child: cellDetailTextLabel2!, top: pictrueHeight+3, left: 20)
            MaterialLayout.size(self, child: cellDetailTextLabel2!, width: UIScreen.mainScreen().bounds.width - 40, height: cellHeight - pictrueHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
