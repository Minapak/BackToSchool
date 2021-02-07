//
//  PendingVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import PinterestLayout
import SwiftyJSON

class PendingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgWallpaper: UIImageView!
    @IBOutlet weak var imgWallpaper_height: NSLayoutConstraint!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imgWallpaper_height.constant = attributes.imageHeight
        }
    }
}

class PendingVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collection_pendingwallpapers: UICollectionView!
    
    //MARK: Variables
    var pendingwallpaperArr = [[String:String]]()
    var pageIndex = 1
    private let refreshControl = UIRefreshControl()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = PinterestLayout()
        self.collection_pendingwallpapers.collectionViewLayout = layout
        layout.delegate = self
        layout.numberOfColumns = 2
        
        self.collection_pendingwallpapers.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshWallpaperData(_:)), for: .valueChanged)
        
        let urlString = API_URL + "getmywallpapers.php"
        let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
            "numberOfRecords":numberOfRecords,
            "user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
            "status":"pending"]
        self.Webservice_PendingWallpapers(url: urlString, params: params)
    }
    
}

//MARK: Functions
extension PendingVC {
    @objc private func refreshWallpaperData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        self.pageIndex = 1
        let urlString = API_URL + "getmywallpapers.php"
        let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
            "numberOfRecords":numberOfRecords,
            "user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
            "status":"pending"]
        self.Webservice_PendingWallpapers(url: urlString, params: params)
    }
}

//MARK: Actions
extension PendingVC {
    @objc func btnDelete_Clicked(sender: UIButton) {
        let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "정말 이 자료를 삭제하시겠습니까?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { (action) in
            let urlString = API_URL + "deletewallpaper.php"
            let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                        "wallpaper_id":self.pendingwallpaperArr[sender.tag]["id"]!]
            self.Webservice_DeleteWallpaper(url: urlString, params: params, wallpaperIndex: sender.tag)
        }
        let noAction = UIAlertAction(title: "아니오", style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

//MARK: Collectionview methods
extension PendingVC: UICollectionViewDelegate,UICollectionViewDataSource,PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.collection_pendingwallpapers.bounds.size.width, height: self.collection_pendingwallpapers.bounds.size.height))
        let noDataImage = UIImageView(frame: rect)
        noDataImage.contentMode = .scaleAspectFit
        noDataImage.image = UIImage(named: "ic_noData")
        self.collection_pendingwallpapers.backgroundView = noDataImage
        if self.pendingwallpaperArr.count == 0 {
            noDataImage.isHidden = false
        }
        else {
            noDataImage.isHidden = true
        }
        return self.pendingwallpaperArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_pendingwallpapers.dequeueReusableCell(withReuseIdentifier: "PendingCollectionCell", for: indexPath) as! PendingCollectionCell
        cell.backgroundColor = UIColor.init(hex: self.pendingwallpaperArr[indexPath.item]["wallpaper_color"]!)
        cell.imgWallpaper.isHidden = true
        cell.imgWallpaper.sd_setImage(with: URL(string: self.pendingwallpaperArr[indexPath.item]["wallpaper_image"]!)) { (image, error, cache, url) in
            cell.imgWallpaper.isHidden = false
        }
        cell.btnDelete.layer.cornerRadius = 20.0
        cell.btnDelete.tag = indexPath.item
        cell.btnDelete.addTarget(self, action: #selector(self.btnDelete_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.pendingwallpaperArr.count - 1 {
            if self.pageIndex != 0 {
                let urlString = API_URL + "getmywallpapers.php"
                let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
                    "numberOfRecords":numberOfRecords,
                    "user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                    "status":"pending"]
                self.Webservice_PendingWallpapers(url: urlString, params: params)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        let wallpaperHeight = Int(self.pendingwallpaperArr[indexPath.item]["wallpaper_height"]!)
        return CGFloat(wallpaperHeight!)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return "".heightForWidth(width: withWidth, font: UIFont.systemFont(ofSize: 0))
    }
}

//MARK: Webservices
extension PendingVC
{
    func Webservice_PendingWallpapers(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let responseData = jsonResponse!["ResponseData"].arrayValue
                    if self.pageIndex == 1 {
                        self.pendingwallpaperArr.removeAll()
                    }
                    if responseData.count < numberOfRecords {
                        self.pageIndex = 0
                    }
                    else {
                        self.pageIndex = self.pageIndex + 1
                    }
                    for data in responseData {
                        let wallpaperObj = ["id":data["id"].stringValue,"wallpaper_image":data["wallpaper_image"].stringValue,"wallpaper_height":data["wallpaper_height"].stringValue,"wallpaper_color":data["wallpaper_color"].stringValue,"user_image":data["user_image"].stringValue,"user_name":data["user_name"].stringValue,"wallpaper_likes":data["wallpaper_likes"].stringValue,"wallpaper_views":data["wallpaper_views"].stringValue,"category_name":data["category_name"].stringValue]
                        self.pendingwallpaperArr.append(wallpaperObj)
                    }
                    self.collection_pendingwallpapers.reloadData()
                }
                else if responseCode == "0" {
                    if self.pageIndex == 1 {
                        self.pendingwallpaperArr.removeAll()
                    }
                    self.pageIndex = 0
                    self.collection_pendingwallpapers.reloadData()
                }
            }
        }
    }
    
    func Webservice_DeleteWallpaper(url:String, params:NSDictionary, wallpaperIndex:Int) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    self.pendingwallpaperArr.remove(at: wallpaperIndex)
                    self.collection_pendingwallpapers.reloadData()
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["ResponseMessage"].stringValue)
                }
            }
        }
    }
}
