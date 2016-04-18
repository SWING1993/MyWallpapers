//
//  CategoryCell.swift
//  MyWallpaper
//
//  Created by 宋国华 on 16/2/24.
//  Copyright © 2016年 宋国华. All rights reserved.
//

import UIKit
import Material
class CategoryCell: MaterialTableViewCell {
    
    private let pictrueWidth:CGFloat = 50
    private let pictrueHeight:CGFloat = 50
    private let labelHeight:CGFloat = 20
    private let labelWidth:CGFloat = UIScreen.mainScreen().bounds.width - 80

    
    var pictrueView:UIImageView!
    var titleLabel:UILabel!
    var nameLabel:UILabel!
    var pictrueUrl:String!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        if pictrueView == nil {
            pictrueView = UIImageView.init()
            pictrueView.contentMode = UIViewContentMode.ScaleAspectFill
            pictrueView.layer.cornerRadius = 50/2
            pictrueView.layer.masksToBounds = true

            self.addSubview(pictrueView!)
            pictrueView!.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromTopLeft(self, child: pictrueView!, top: 10, left: 10)
            MaterialLayout.size(self, child: pictrueView!, width: pictrueWidth, height: pictrueHeight)
        }
        
        if titleLabel == nil {
            titleLabel = UILabel.init()
            titleLabel.numberOfLines = 1
            titleLabel.font = RobotoFont.thinWithSize(13.5)

            self.addSubview(titleLabel)
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromBottomLeft(self, child: titleLabel, bottom: 15, left: 70)
            MaterialLayout.size(self, child: titleLabel, width: labelWidth, height: labelHeight)
            
        
        }
        
        if nameLabel == nil {
            nameLabel = UILabel.init()
            nameLabel.numberOfLines = 1
            nameLabel.font = RobotoFont.mediumWithSize(13.0)

            self.addSubview(nameLabel)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            MaterialLayout.alignFromBottomLeft(self, child: nameLabel, bottom: 15 + labelHeight, left: 70)
            MaterialLayout.size(self, child: nameLabel, width: labelWidth, height: labelHeight)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
