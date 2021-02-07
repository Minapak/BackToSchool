//
//  ApprovedVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import PinterestLayout
import SwiftyJSON

class ApprovedCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgWallpaper: UIImageView!
    @IBOutlet weak var imgWallpaper_height: NSLayoutConstraint!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imgWallpaper_height.constant = attributes.imageHeight
        }
    }
}

class ApprovedVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collection_approvedwallpapers: UICollectionView!
    
    //MARK: Variables
    var approvedwallpaperArr = [[String:String]]()
    var pageIndex = 1
    private let refreshControl = UIRefreshControl()
    
    //MARK: Viewcontrolelr lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = PinterestLayout()
        self.collection_approvedwallpapers.collectionViewLayout = layout
        layout.delegate = self
        layout.numberOfColumns = 2
        
        self.collection_approvedwallpapers.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshWallpaperData(_:)), for: .valueChanged)
        
        let urlString = API_URL + "getmywallpapers.php"
        let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
            "numberOfRecords":numberOfRecords,
            "user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
            "status":"approved"]
        self.Webservice_ApprovedWallpapers(url: urlString, params: params)
    }
    
}

//MARK: Functions
extension ApprovedVC {
    @objc private func refreshWallpaperData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        self.pageIndex = 1
        let urlString = API_URL + "getmywallpapers.php"
        let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
            "numberOfRecords":numberOfRecords,
            "user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
            "status":"approved"]
        self.Webservice_ApprovedWallpapers(url: urlString, params: params)
    }
}

//MARK: Actions
extension ApprovedVC {
    @objc func btnDelete_Clicked(sender: UIButton) {
        let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "정말 이 자료를 삭제하시겠습니까?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { (action) in
            let urlString = API_URL + "deletewallpaper.php"
            let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                        "wallpaper_id":self.approvedwallpaperArr[sender.tag]["id"]!]
            self.Webservice_DeleteWallpaper(url: urlString, params: params, wallpaperIndex: sender.tag)
        }
        let noAction = UIAlertAction(title: "아니오", style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

//MARK: Collectionview methods
extension ApprovedVC: UICollectionViewDelegate,UICollectionViewDataSource,PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.collection_approvedwallpapers.bounds.size.width, height: self.collection_approvedwallpapers.bounds.size.height))
        let noDataImage = UIImageView(frame: rect)
        noDataImage.contentMode = .scaleAspectFit
        noDataImage.image = UIImage(named: "ic_noData")
        self.collection_approvedwallpapers.backgroundView = noDataImage
        if self.approvedwallpaperArr.count == 0 {
            noDataImage.isHidden = false
        }
        else {
            noDataImage.isHidden = true
        }
        return self.approvedwallpaperArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_approvedwallpapers.dequeueReusableCell(withReuseIdentifier: "ApprovedCollectionCell", for: indexPath) as! ApprovedCollectionCell
        cell.backgroundColor = UIColor.init(hex: self.approvedwallpaperArr[indexPath.item]["wallpaper_color"]!)
        cell.imgWallpaper.isHidden = true
        cell.imgWallpaper.sd_setImage(with: URL(string: self.approvedwallpaperArr[indexPath.item]["wallpaper_image"]!)) { (image, error, cache, url) in
            cell.imgWallpaper.isHidden = false
        }
        cell.lblViews.layer.cornerRadius = 10.0
        cell.lblViews.text = "        " + self.approvedwallpaperArr[indexPath.item]["wallpaper_views"]! + "  "
        cell.lblLikes.layer.cornerRadius = 10.0
        cell.lblLikes.text = "        " + self.approvedwallpaperArr[indexPath.item]["wallpaper_likes"]! + "  "
        cell.btnDelete.layer.cornerRadius = 20.0
        cell.btnDelete.tag = indexPath.item
        cell.btnDelete.addTarget(self, action: #selector(self.btnDelete_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.approvedwallpaperArr.count - 1 {
            if self.pageIndex != 0 {
                let urlString = API_URL + "getmywallpapers.php"
                let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
                    "numberOfRecords":numberOfRecords,
                    "user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                    "status":"approved"]
                self.Webservice_ApprovedWallpapers(url: urlString, params: params)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        let wallpaperHeight = Int(self.approvedwallpaperArr[indexPath.item]["wallpaper_height"]!)
        return CGFloat(wallpaperHeight!)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return "".heightForWidth(width: withWidth, font: UIFont.systemFont(ofSize: 0))
    }
}

//MARK: Webservices
extension ApprovedVC
{
    func Webservice_ApprovedWallpapers(url:String, params:NSDictionary) -> Void {
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
                        self.approvedwallpaperArr.removeAll()
                    }
                    if responseData.count < numberOfRecords {
                        self.pageIndex = 0
                    }
                    else {
                        self.pageIndex = self.pageIndex + 1
                    }
                    for data in responseData {
                        let wallpaperObj = ["id":data["id"].stringValue,"wallpaper_image":data["wallpaper_image"].stringValue,"wallpaper_height":data["wallpaper_height"].stringValue,"wallpaper_color":data["wallpaper_color"].stringValue,"user_image":data["user_image"].stringValue,"user_name":data["user_name"].stringValue,"wallpaper_likes":data["wallpaper_likes"].stringValue,"wallpaper_views":data["wallpaper_views"].stringValue,"category_name":data["category_name"].stringValue]
                        self.approvedwallpaperArr.append(wallpaperObj)
                    }
                    self.collection_approvedwallpapers.reloadData()
                }
                else if responseCode == "0" {
                    if self.pageIndex == 1 {
                        self.approvedwallpaperArr.removeAll()
                    }
                    self.pageIndex = 0
                    self.collection_approvedwallpapers.reloadData()
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
                    self.approvedwallpaperArr.remove(at: wallpaperIndex)
                    self.collection_approvedwallpapers.reloadData()
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["ResponseMessage"].stringValue)
                }
            }
        }
    }
}
