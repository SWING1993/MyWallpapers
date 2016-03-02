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
	var summary: String
    var thumb: String
    var thumb_hd: String
    var cover: String
    var cover_hd: String
	var photo_count: NSNumber
    var album :NSArray
}

private enum RefreshStatus {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
}

class FeaturesController: UIViewController {
    
    private var listArray : NSMutableArray = NSMutableArray()

	/// A tableView used to display Bond entries.
    
    
    private var kWidth :CGFloat = UIScreen.mainScreen().bounds.width
    private let cellHeight:CGFloat = UIScreen.mainScreen().bounds.height/3
    private var kSectionHeader_height :CGFloat = 20
	private let tableView: UITableView = UITableView()
    private var pageNum:Int = Int()
    private var refreshStatus = RefreshStatus.none

	/// A list of all the Author Bond types.
	private var items: Array<Item> = Array<Item>()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareView()
		prepareItems()
		prepareTableView()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(FeaturesController.callMeHeader))
        self.tableView.mj_header.beginRefreshing()
    }
    
    /// Prepares the tableView.
    private func prepareTableView() {
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.registerClass(MainCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = cellHeight
        tableView.separatorStyle = .SingleLine
        // Use MaterialLayout to easily align the tableView.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignToParent(view, child: tableView, top: 0)
    }
    
    @objc private func callMeHeader() {
        self.pageNum = 1
        loadData(self.pageNum)
        self.refreshStatus = RefreshStatus.beginHeaderRefresh
    }
    
    private func loadData(page:Int) {
        let parametersDic = NSDictionary.init(dictionary: [
            "page" : page,
            "ver" : "iphone",
            "app_ver" : "12"
            ])
        
        Alamofire.request(.GET, "http://paper-cdn.2q10.com/api/list/feature/zh-hans", parameters: parametersDic as? [String : AnyObject]).responseJSON{ response in
            if let JSON = response.result.value {
                let JSONArr:NSArray = JSON as! NSArray
                let modelArr :NSMutableArray = NSMutableArray()
                if JSONArr.count>0 {
                    for JSONDict in JSONArr {
                        let model = FeatureModel()
                        let dict :NSDictionary = JSONDict as! NSDictionary
                        if (dict.objectForKey("guid") != nil) {
                            model.guid = dict.objectForKey("guid") as! NSNumber
                        }
                        if (dict.objectForKey("type") != nil) {
                            model.type = dict.objectForKey("type") as! NSNumber
                        }
                        if (dict.objectForKey("title") != nil) {
                            model.title = dict.objectForKey("title") as! String
                        }
                        if (dict.objectForKey("thumb") != nil) {
                            model.thumb = dict.objectForKey("thumb") as! String
                        }
                        if (dict.objectForKey("thumb_hd") != nil) {
                            model.thumb_hd = dict.objectForKey("thumb_hd") as! String
                        }
                        if (dict.objectForKey("cover") != nil) {
                            model.cover = dict.objectForKey("cover") as! String
                        }
                        if (dict.objectForKey("cover_hd") != nil) {
                            model.cover_hd = dict.objectForKey("cover_hd") as! String
                        }
                        if (dict.objectForKey("cover_hd_568h") != nil) {
                            model.cover_hd_568h = dict.objectForKey("cover_hd_568h") as! String
                        }
                        if (dict.objectForKey("pubdate") != nil) {
                            model.pubdate = dict.objectForKey("pubdate") as! String
                        }
                        if (dict.objectForKey("archive_timestamp") != nil) {
                            model.archive_timestamp = dict.objectForKey("archive_timestamp") as! NSNumber
                        }
                        if (dict.objectForKey("timestamp") != nil) {
                            model.timestamp = dict.objectForKey("timestamp") as! NSNumber
                        }
                        if (dict.objectForKey("summary") != nil) {
                            model.summary = dict.objectForKey("summary") as! String
                        }
                        if (dict.objectForKey("photo_count") != nil) {
                            model.photo_count = dict.objectForKey("photo_count") as! NSNumber
                        }
                        if (dict.objectForKey("album") != nil) {
                            model.album = dict.objectForKey("album") as! NSArray
                        }
                 
                        
                        modelArr.addObject(model)
                    }
                    modelArr.removeObjectAtIndex(0)
                    self.listArray = modelArr
                    self.prepareItems()
                }
            }
        }
    }
    
    /// Prepares the items Array.
    private func prepareItems() {
        if self.pageNum == 1 {
            items.removeAll()
            for model in self.listArray {
                let featureModel:FeatureModel = model as! FeatureModel
                items.append(Item(
                    title: featureModel.title as String,
                    summary: featureModel.summary as String,
                    thumb: featureModel.thumb as String,
                    thumb_hd: featureModel.thumb_hd as String,
                    cover: featureModel.cover as String,
                    cover_hd: featureModel.cover_hd as String,
                    photo_count: featureModel.photo_count,
                    album: featureModel.album
                    ))
            }
            self.tableView.reloadData()
        }
        else {
            for model in self.listArray {
                let featureModel:FeatureModel = model as! FeatureModel
                items.append(Item(
                    title: featureModel.title as String,
                    summary: featureModel.summary as String,
                    thumb: featureModel.thumb as String,
                    thumb_hd: featureModel.thumb_hd as String,
                    cover: featureModel.cover as String,
                    cover_hd: featureModel.cover_hd as String,
                    photo_count: featureModel.photo_count,
                    album: featureModel.album
                    ))
            }
            self.tableView.reloadData()
        }
        if self.refreshStatus == RefreshStatus.beginHeaderRefresh {
            self.tableView.mj_header.endRefreshing()
            self.refreshStatus == RefreshStatus.endHeaderRefresh
        }
    }

	/// Prepares view.
	private func prepareView() {
		view.backgroundColor = MaterialColor.white
	}
}

/// TableViewDataSource methods.
extension FeaturesController: UITableViewDataSource {
	/// Determines the number of rows in the tableView.
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	/// Returns the number of sections.
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return items.count
	}
	
	/// Prepares the cells within the tableView.
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: MainCell = MainCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = .None

		let item: Item = items[indexPath.section]
		cell.cellDetailTextLabel2!.text = item.summary
        
        if item.album.count>0 {
            for (index, value) in EnumerateSequence(item.album) {
                let dict :NSDictionary = value as! NSDictionary
                if (dict.objectForKey("thumb") != nil) {
                    if index == 0 {
                        cell.cellImageView1?.sd_setImageWithURL(NSURL.init(string: dict.objectForKey("thumb") as! NSString as String))
                    }
                    if index == 1 {
                        cell.cellImageView2?.sd_setImageWithURL(NSURL.init(string: dict.objectForKey("thumb") as! NSString as String))
                    }
                    if index == 2 {
                        cell.cellImageView3?.sd_setImageWithURL(NSURL.init(string: dict.objectForKey("thumb") as! NSString as String))
                    }
                    if index == 3 {
                        break
                    }
                }
            }
        }
		return cell
	}
    
    /// Prepares the header within the tableView.
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, view.bounds.width, kSectionHeader_height))
        header.backgroundColor = MaterialColor.white
        
        let item: Item = items[section]
        
        
        let label: UILabel = UILabel()
        label.font = RobotoFont.mediumWithSize(14)
        label.textColor = MaterialColor.black
        label.text = "PICS - "+String(item.photo_count)
        header.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTopLeft(header, child: label, left: 20)
        MaterialLayout.size(header, child: label, width: kWidth/2-20, height: kSectionHeader_height)
        
        let label2: UILabel = UILabel()
        label2.textAlignment = NSTextAlignment.Right
        label2.font = RobotoFont.mediumWithSize(13)
        label2.textColor = MaterialColor.black
        label2.text = item.title
        header.addSubview(label2)
        label2.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTopLeft(header, child: label2, left: kWidth/2)
        MaterialLayout.size(header, child: label2, width: kWidth/2-20, height: kSectionHeader_height)
        
        return header
    }

    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRectMake(0, 0, view.bounds.width, 0.5))
        footer.backgroundColor = MaterialColor.grey.base
        return footer
    }

    
    //didDeselectRowAtIndexPath
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item: Item = items[indexPath.section]
        let todayVC :PictrueViewController = PictrueViewController()
        todayVC.title = item.title
        todayVC.albumsArr = item.album.mutableCopy() as! NSMutableArray
        todayVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(todayVC, animated: true)
    }
}

/// UITableViewDelegate methods.
extension FeaturesController: UITableViewDelegate {
	/// Sets the tableView header height.
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return kSectionHeader_height
	}
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}
