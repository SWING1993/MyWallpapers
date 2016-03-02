//
//  TodayViewController.swift
//  MyWallpaper
//
//  Created by 宋国华 on 16/1/22.
//  Copyright © 2016年 宋国华. All rights reserved.
//

import UIKit
import Material
import Alamofire
import MWPhotoBrowser
import MJRefresh

private struct Item {
    var title: String
    var content: String
    var pubdate: String
    var thumb: String
    var thumb_hd: String
    var cover: String
    var cover_hd: String
    var cover_hd_568h: String
}

private enum RefreshStatus {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
    case beginfooterRefresh
    case endFooterRefresh
}

class TodayController: UIViewController {
    
    private var kWidth :CGFloat = UIScreen.mainScreen().bounds.width
    private var kSectionHeader_height :CGFloat = 20
    private var listArray : NSMutableArray = NSMutableArray()
    private let tableView: UITableView = UITableView()
    private let cellHeight:CGFloat = UIScreen.mainScreen().bounds.height/3
    /// A list of all the Author Bond types.
    private var items: Array<Item> = Array<Item>()
    private let photos:NSMutableArray! = NSMutableArray.init(capacity: 0)
    private var pageNum:Int = Int()
    private var refreshStatus = RefreshStatus.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageNum = 1
        prepareTableView()
    }
    
    private func prepareTableView() {
        tableView.registerClass(MainCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.rowHeight = cellHeight
        // Use MaterialLayout to easily align the tableView.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignToParent(view, child: tableView, top: 0)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(TodayController.callMeHeader))
        self.tableView.mj_header.beginRefreshing()
        self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget:self, refreshingAction:#selector(TodayController.callMeFooter))
    }

    
    @objc private func callMeHeader() {
        self.pageNum = 1
        loadData(self.pageNum)
        self.refreshStatus = RefreshStatus.beginHeaderRefresh
    }
    
    @objc private func callMeFooter() {
        //...
        self.pageNum += 1
        loadData(self.pageNum)
        self.refreshStatus = RefreshStatus.beginfooterRefresh
    }
    
    
    private func loadData(page:Int) {
        let parametersDic = NSDictionary.init(dictionary: [
            "page" : page,
            "ver" : "iphone",
            "app_ver" : "12"
            ])
        
        Alamofire.request(.GET, "http://paper-cdn.2q10.com/api/list/today/zh-hans", parameters: parametersDic as? [String : AnyObject]).responseJSON{ response in
            if let JSONArr = response.result.value as? NSArray {
                let modelArr :NSMutableArray = NSMutableArray()
                if JSONArr.count>0 {
                    for JSONDict in JSONArr {
                        let model = PictrueListModel()
                        let dict :NSDictionary = JSONDict as! NSDictionary

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
                        if (dict.objectForKey("content") != nil) {
                            model.content = dict.objectForKey("content") as! String
                        }
                        if (dict.objectForKey("website") != nil) {
                            model.website = dict.objectForKey("website") as! String
                        }
                        modelArr.addObject(model)
                    }
                    
                    modelArr.removeLastObject()
                    self.listArray = modelArr
                    self.prepareItems()
                }
            }
        }
    }
    
    /// Prepares the items Array.
    private func prepareItems() {
        switch self.refreshStatus {
        case RefreshStatus.none:
            break
        case RefreshStatus.beginHeaderRefresh:
            items.removeAll()
            for model in self.listArray {
                let pictrueModel:PictrueListModel = model as! PictrueListModel
                if model.website.isEmpty {
                    items.append(Item(
                        title: pictrueModel.title as String,
                        content: pictrueModel.content as String,
                        pubdate: pictrueModel.pubdate as String,
                        thumb: pictrueModel.thumb as String,
                        thumb_hd: pictrueModel.thumb_hd as String,
                        cover: pictrueModel.cover as String,
                        cover_hd: pictrueModel.cover_hd as String,
                        cover_hd_568h :pictrueModel.cover_hd_568h as String
                        ))
                }
            }

            self.tableView.mj_header.endRefreshing()
            self.refreshStatus = RefreshStatus.endHeaderRefresh
            self.tableView.reloadData()
            break
            
        case RefreshStatus.beginfooterRefresh:
            for model in self.listArray {
                let pictrueModel:PictrueListModel = model as! PictrueListModel
                if model.website.isEmpty {
                    items.append(Item(
                        title: pictrueModel.title as String,
                        content: pictrueModel.content as String,
                        pubdate: pictrueModel.pubdate as String,
                        thumb: pictrueModel.thumb as String,
                        thumb_hd: pictrueModel.thumb_hd as String,
                        cover: pictrueModel.cover as String,
                        cover_hd: pictrueModel.cover_hd as String,
                        cover_hd_568h :pictrueModel.cover_hd_568h as String
                        ))
                }
            }
            self.tableView.mj_footer.endRefreshing()
            self.refreshStatus = RefreshStatus.endFooterRefresh
            self.tableView.reloadData()
            break
        default:
            break
        }
        print(self.refreshStatus,"刷新第",self.pageNum,"页",items.count)
     }
}

/// TableViewDataSource methods.
extension TodayController: UITableViewDataSource {
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
        let cell: TodayCell = TodayCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.selectionStyle = .None
        let item: Item = items[indexPath.section]
        cell.pictrueView.sd_setImageWithURL(NSURL.init(string: item.thumb_hd))
        cell.contentLabel.text = item.content
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
        label.text = item.title
        header.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTopLeft(header, child: label, left: 20)
        MaterialLayout.size(header, child: label, width: kWidth/2-20, height: kSectionHeader_height)

        let label2: UILabel = UILabel()
        label2.textAlignment = NSTextAlignment.Right
        label2.font = RobotoFont.mediumWithSize(13)
        label2.textColor = MaterialColor.black
        label2.text = item.pubdate
        header.addSubview(label2)
        label2.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTopLeft(header, child: label2, left: kWidth/2)
        MaterialLayout.size(header, child: label2, width: kWidth/2-20, height: kSectionHeader_height)

        return header
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let tableViewFooter = UIView(frame: CGRectMake(0, 0, view.bounds.width, 15))
//        tableViewFooter.backgroundColor = MaterialColor.grey.base
//        return tableViewFooter
//    }
    
    //didDeselectRowAtIndexPath
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        
        self.photos.removeAllObjects()

        let item: Item = items[indexPath.section]
        let photo :MWPhoto = MWPhoto.init(URL: NSURL.init(string: item.cover_hd_568h as String))
        photo.caption =  item.content as String
        self.photos.addObject(photo)
        let browser:MWPhotoBrowser = MWPhotoBrowser.init()
        browser.delegate = self
        browser.title = item.title as String
        browser.setCurrentPhotoIndex(0)
        self.navigationController?.pushViewController(browser, animated: true)

    }
}

/// UITableViewDelegate methods.
extension TodayController: UITableViewDelegate {
    /// Sets the tableView header height.
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kSectionHeader_height
    }
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 15
//    }
}

/// MWPhotoBrowserDelegate methods.
extension TodayController:MWPhotoBrowserDelegate {
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        let count:UInt = UInt.init(self.photos.count)
        return count
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        let count_Uint:UInt = UInt.init(self.photos.count)
        let index_Int:Int = Int.init(index)
        
        let photo:MWPhoto = self.photos.objectAtIndex(index_Int) as! MWPhoto
        if index < count_Uint {
            return photo
        }
        return nil
    }
}