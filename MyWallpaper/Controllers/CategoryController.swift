//
//  MainViewController.swift
//  MyWallpaper
//
//  Created by 宋国华 on 16/1/23.
//  Copyright © 2016年 宋国华. All rights reserved.
//

import UIKit
import Alamofire
import Material
import MJRefresh


private struct Item {
	var title: String
	var name: String
	var total: NSNumber
    var thumb: String
    var alias: String
}

class CategoryController: UIViewController {
	/// A tableView used to display navigation items.
	private let tableView: UITableView = UITableView()
	
	/// A list of all the navigation items.
	private var items: Array<Item> = Array<Item>()
    private var listArray : NSMutableArray = NSMutableArray()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("loadData"))
        self.tableView.mj_header.beginRefreshing()
		prepareView()
		prepareTableView()
        loadData()
	}
	
	/// General preparation statements.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
    
    /// Prepares the tableView.
    private func prepareTableView() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SideCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .SingleLine
        
        // Use MaterialLayout to easily align the tableView.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignToParent(view, child: tableView, top: 0)
    }
	 
	/// Prepares the items that are displayed within the tableView.
	private func prepareItems() {
        items.removeAll()
        for model in self.listArray {
            let categoryModel:CategoryModel = model as! CategoryModel
            items.append(Item(
                title: categoryModel.title as String,
                name: categoryModel.name as String,
                total: categoryModel.total,
                thumb:categoryModel.thumb as String,
                alias: categoryModel.alias as String
                ))
        }
        self.tableView.mj_header.endRefreshing()
        self.tableView.reloadData()
	}
	
	/// Prepares profile view.
	private func prepareProfileView() {
		let backgroundView: MaterialView = MaterialView()
		backgroundView.image = UIImage(named: "ProfileSideNavBackground")
		
		let profileView: MaterialView = MaterialView()
		profileView.image = UIImage(named: "Profile9")?.resize(toWidth: 72)
		profileView.shape = .Circle
		profileView.borderColor = MaterialColor.white
//		profileView.borderWidth = .Border3
		
		let nameLabel: UILabel = UILabel()
		nameLabel.text = "Michael Smith"
		nameLabel.textColor = MaterialColor.white
		nameLabel.font = RobotoFont.mediumWithSize(18)
		
		view.addSubview(backgroundView)
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTop(view, child: backgroundView)
		MaterialLayout.alignToParentHorizontally(view, child: backgroundView)
		MaterialLayout.height(view, child: backgroundView, height: 170)
		
		backgroundView.addSubview(profileView)
		profileView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromTopLeft(backgroundView, child: profileView, top: 20, left: 20)
		MaterialLayout.size(backgroundView, child: profileView, width: 72, height: 72)
		
		backgroundView.addSubview(nameLabel)
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignFromBottom(backgroundView, child: nameLabel, bottom: 20)
		MaterialLayout.alignToParentHorizontally(backgroundView, child: nameLabel, left: 20, right: 20)
	}
	

    
    @objc private func loadData() {
        let parametersDic = NSDictionary.init(dictionary: [
            "ver" : "iphone",
            "app_ver" : "12"
            ])
        Alamofire.request(.GET, "http://paper-cdn.2q10.com/api/category/iphone", parameters: parametersDic as? [String : AnyObject]).responseJSON{ response in
            if let JSON = response.result.value {
                let JSONArr:NSArray = JSON as! NSArray
                let modelArr :NSMutableArray = NSMutableArray()
                if JSONArr.count>0 {
                    for JSONDict in JSONArr {
                        let model = CategoryModel()
                        let dict :NSDictionary = JSONDict as! NSDictionary
                        if (dict.objectForKey("id") != nil) {
                            model.id = dict.objectForKey("id") as! NSNumber
                        }
                        if (dict.objectForKey("alias") != nil) {
                            model.alias = dict.objectForKey("alias") as! String
                        }
                        if (dict.objectForKey("title") != nil) {
                            model.title = dict.objectForKey("title") as! String
                        }
                        if (dict.objectForKey("name") != nil) {
                            model.name = dict.objectForKey("name") as! String
                        }
                        if (dict.objectForKey("total") != nil) {
                            model.total = dict.objectForKey("total") as! NSNumber
                        }
                        if (dict.objectForKey("lastupdate") != nil) {
                            model.lastupdate = dict.objectForKey("lastupdate") as! NSNumber
                        }
                        if (dict.objectForKey("thumb") != nil) {
                            model.thumb = dict.objectForKey("thumb") as! String
                        }

                        modelArr.addObject(model)
                    }
                    self.listArray = modelArr
                    self.listArray.removeLastObject()
                    self.prepareItems()
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let item: Item = items[indexPath.row]
        let todayVC :PictrueViewController = PictrueViewController()
        todayVC.title = item.name
        todayVC.urlString = "http://paper-cdn.2q10.com/api/list/"+item.alias+"/zh-hans"
        todayVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(todayVC, animated: true)
    }
}

/// TableViewDataSource methods.
extension CategoryController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count;
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell:CategoryCell = CategoryCell.init(style: .Subtitle, reuseIdentifier: "SideCell")
        cell.selectionStyle = .None
        let item: Item = items[indexPath.row]
        cell.pictrueView.sd_setImageWithURL(NSURL.init(string: item.thumb as String), placeholderImage: UIImage.init(named: "Pic"))
        cell.titleLabel.text = item.title+"【"+String(item.total)+"】"
        cell.nameLabel.text =  item.name

		return cell
	}
}

/// UITableViewDelegate methods.
extension CategoryController: UITableViewDelegate {
	/// Sets the tableView cell height.
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 70
	}
}
