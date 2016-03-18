//
//  TodayViewController.swift
//  MyWallpaper
//
//  Created by 宋国华 on 16/1/22.
//  Copyright © 2016年 宋国华. All rights reserved.
//

import UIKit
import Alamofire
import MWPhotoBrowser
import Material
import MJRefresh

private enum RefreshStatus {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
    case beginfooterRefresh
    case endFooterRefresh
}

class PictrueViewController: UIViewController {
    
    internal var albumsArr:NSMutableArray! = NSMutableArray.init(capacity: 0)
    internal var urlString:String?
    private var pictrueCollectionView:UICollectionView!
    private var dataArray : NSMutableArray = NSMutableArray()
    private let sizeThumbnailCollectionView:CGFloat = (UIScreen.mainScreen().bounds.size.width - 20)/3
    private let photos:NSMutableArray! = NSMutableArray.init(capacity: 0)
    private var pageNum:Int = Int()
    private var refreshStatus = RefreshStatus.none


    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        if (self.urlString != nil) {
            self.pageNum = 1
            self.pictrueCollectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("callMeHeader"))
            self.pictrueCollectionView.mj_header.beginRefreshing()
            self.pictrueCollectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget:self, refreshingAction:Selector("callMeFooter"))
        }
        if self.albumsArr.count > 0 {
            loadModelData(self.albumsArr)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func prepareCollectionView () {
        self.view.backgroundColor = MaterialColor.white
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5.0
        layout.minimumLineSpacing = 5.0
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.pictrueCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height-64), collectionViewLayout: layout)
        self.pictrueCollectionView.showsVerticalScrollIndicator  = false
        self.pictrueCollectionView.delegate = self
        self.pictrueCollectionView.dataSource = self
        self.pictrueCollectionView.registerClass(UICollectionViewCell.self,
            forCellWithReuseIdentifier: "ViewCell")
        //默认背景是黑色和label一致
        self.pictrueCollectionView.backgroundColor = MaterialColor.white
        self.view.addSubview(pictrueCollectionView)
        
    }
    
    
    @objc private func callMeHeader() {
        //...
        self.pageNum = 1
        loadData(self.pageNum, url: self.urlString!)
        self.refreshStatus = RefreshStatus.beginHeaderRefresh
    }
    
    @objc private func callMeFooter() {
        //...
        self.pageNum += 1
        loadData(pageNum, url: self.urlString!)
        self.refreshStatus = RefreshStatus.beginfooterRefresh
    }
    
    private func loadData(page:Int,url:String) {
        let parametersDic = NSDictionary.init(dictionary: [
            "page" : page,
            "ver" : "iphone",
            "app_ver" : "12"
            ])
        Alamofire.request(.GET, url, parameters: parametersDic as? [String : AnyObject]).responseJSON{ response in
            if let JSON = response.result.value as? NSArray {
                self.loadModelData(JSON)
            }else {
                switch self.refreshStatus {
                case RefreshStatus.none:
                    break
                    
                case RefreshStatus.beginHeaderRefresh:
                    self.pictrueCollectionView.mj_header.endRefreshing()
                    self.refreshStatus = RefreshStatus.endHeaderRefresh
                    
                    break
                    
                case RefreshStatus.beginfooterRefresh:
                    self.pictrueCollectionView.mj_footer.endRefreshing()
                    self.refreshStatus = RefreshStatus.endFooterRefresh
                    break
                    
                default:
                    break
                }

            }
        }
    }

    private func loadModelData(JSONArr:NSArray) {
    
        let modelArr :NSMutableArray = NSMutableArray()
        for JSONDict in JSONArr {
            let model = PictrueListModel()
            let dict :NSDictionary = JSONDict as! NSDictionary
            if (dict.objectForKey("title") != nil) {
                model.title = dict.objectForKey("title") as! String
            }
            if (dict.objectForKey("content") != nil) {
                model.content = dict.objectForKey("content") as! String
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
            if dict.objectForKey("cover_hd") == nil {
                break
            }
            modelArr.addObject(model)
        }
        switch self.refreshStatus {
        case RefreshStatus.none:
            self.dataArray = modelArr
            self.pictrueCollectionView.reloadData()
            break
            
        case RefreshStatus.beginHeaderRefresh:
            self.pictrueCollectionView.mj_header.endRefreshing()
            self.dataArray = modelArr
            self.pictrueCollectionView.reloadData()
            self.refreshStatus = RefreshStatus.endHeaderRefresh


            break
            
        case RefreshStatus.beginfooterRefresh:
            self.pictrueCollectionView.mj_footer.endRefreshing()
            self.dataArray.addObjectsFromArray(modelArr as [AnyObject])
            self.pictrueCollectionView.reloadData()
            self.refreshStatus = RefreshStatus.endFooterRefresh


            break
        default:
            break
        
        }
        print(self.refreshStatus,"刷新第",self.pageNum,"页",self.dataArray.count)

    }
}

/// MWPhotoBrowserDelegate methods.
extension PictrueViewController:MWPhotoBrowserDelegate {
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

/// UICollectionViewDataSource methods.
extension PictrueViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(sizeThumbnailCollectionView, sizeThumbnailCollectionView*4/3);
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    
    
    // CollectionView行数
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return dataArray.count;
    }
    
    // 获取单元格
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // storyboard里设计的单元格
        let identify:String = "ViewCell"
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = self.pictrueCollectionView.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as UICollectionViewCell
        // initmodel
        let cellModel :PictrueListModel = self.dataArray.objectAtIndex(indexPath.row) as! PictrueListModel
        
        // 添加图片
        let img = UIImageView.init(frame: cell.bounds)
        img.contentMode = UIViewContentMode.ScaleAspectFill
        img.clipsToBounds = true
        img.sd_setImageWithURL(NSURL.init(string: cellModel.thumb_hd as String), placeholderImage: nil)
//        cell.contentView.addSubview(img)
        cell.backgroundView = img
        return cell
    }

}

/// UICollectionViewDelegate methods.
extension PictrueViewController: UICollectionViewDelegate {
    /// Sets the tableView cell height.
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // initmodel
        self.photos.removeAllObjects()
        let cellModel :PictrueListModel = self.dataArray.objectAtIndex(indexPath.row) as! PictrueListModel
    
        var imageUrl:String = String()
        if cellModel.cover_hd_568h.isEmpty {
            imageUrl = cellModel.cover_hd as String
        }else {
            imageUrl = cellModel.cover_hd_568h as String
        }
        let photo :MWPhoto = MWPhoto.init(URL: NSURL.init(string: imageUrl))
        print(cellModel.cover_hd_568h)
        photo.caption =  cellModel.content as String
        self.photos.addObject(photo)
        let browser:MWPhotoBrowser = MWPhotoBrowser.init()
        browser.delegate = self
        browser.title = cellModel.title as String
        browser.setCurrentPhotoIndex(0)
        self.navigationController?.pushViewController(browser, animated: true)
    }
}
