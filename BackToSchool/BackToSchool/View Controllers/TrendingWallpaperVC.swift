//
//  TrendingWallpaperVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//


import UIKit
import PinterestLayout
import SwiftyJSON

class TrendingCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgWallpaper: UIImageView!
    @IBOutlet weak var imgWallpaper_height: NSLayoutConstraint!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblViews: UILabel!
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imgWallpaper_height.constant = attributes.imageHeight
        }
    }
}

class TrendingWallpaperVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collection_trendingwallpapers: UICollectionView!
    
    //MARK: Variables
    var trendingWallpaperArr = [[String:String]]()
    var pageIndex = 1
    private let refreshControl = UIRefreshControl()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = PinterestLayout()
        self.collection_trendingwallpapers.collectionViewLayout = layout
        layout.delegate = self
        layout.numberOfColumns = 2
        
        self.collection_trendingwallpapers.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshWallpaperData(_:)), for: .valueChanged)
        
        var userId = ""
        if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
            userId = ""
        }
        else {
            userId = UserDefaults.standard.value(forKey: UD_userId) as! String
        }
        let urlString = API_URL + "gettrendingwallpapers.php"
        let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
            "numberOfRecords":numberOfRecords,
            "user_id":userId]
        self.Webservice_TrendingWallpapers(url: urlString, params: params)
    }
    
}

//MARK: Functions
extension TrendingWallpaperVC {
    @objc private func refreshWallpaperData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        self.pageIndex = 1
        var userId = ""
        if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
            userId = ""
        }
        else {
            userId = UserDefaults.standard.value(forKey: UD_userId) as! String
        }
        let urlString = API_URL + "gettrendingwallpapers.php"
        let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
            "numberOfRecords":numberOfRecords,
            "user_id":userId]
        self.Webservice_TrendingWallpapers(url: urlString, params: params)
    }
}

//MARK: Actions
extension TrendingWallpaperVC {
    @objc func btnLike_Clicked(sender: UIButton) {
        if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            UIApplication.shared.windows[0].rootViewController = nav
        }
        else {
            if self.trendingWallpaperArr[sender.tag]["isFavourite"] == "2" {
                let urlString = API_URL + "favouriteunfavourite.php"
                let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                            "wallpaper_id":self.trendingWallpaperArr[sender.tag]["id"]!,
                                            "favourite":"1"]
                self.Webservice_FavouriteUnfavouriteWallpaper(url: urlString, params: params, wallpaperIndex: sender.tag, isFavourite: "1")
            }
            else {
                let urlString = API_URL + "favouriteunfavourite.php"
                let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                            "wallpaper_id":self.trendingWallpaperArr[sender.tag]["id"]!,
                                            "favourite":"2"]
                self.Webservice_FavouriteUnfavouriteWallpaper(url: urlString, params: params, wallpaperIndex: sender.tag, isFavourite: "2")
            }
        }
    }
}

//MARK: Collectionview methods
extension TrendingWallpaperVC: UICollectionViewDelegate,UICollectionViewDataSource,PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.collection_trendingwallpapers.bounds.size.width, height: self.collection_trendingwallpapers.bounds.size.height))
        let noDataImage = UIImageView(frame: rect)
        noDataImage.contentMode = .scaleAspectFit
        noDataImage.image = UIImage(named: "ic_noData")
        self.collection_trendingwallpapers.backgroundView = noDataImage
        if self.trendingWallpaperArr.count == 0 {
            noDataImage.isHidden = false
        }
        else {
            noDataImage.isHidden = true
        }
        return self.trendingWallpaperArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_trendingwallpapers.dequeueReusableCell(withReuseIdentifier: "TrendingCollectionCell", for: indexPath) as! TrendingCollectionCell
        cell.backgroundColor = UIColor.init(hex: self.trendingWallpaperArr[indexPath.item]["wallpaper_color"]!)
        cell.imgWallpaper.isHidden = true
        cell.imgWallpaper.sd_setImage(with: URL(string: self.trendingWallpaperArr[indexPath.item]["wallpaper_image"]!)) { (image, error, cache, url) in
            cell.imgWallpaper.isHidden = false
        }
        if self.trendingWallpaperArr[indexPath.item]["isFavourite"] == "2" {
            cell.btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        else {
            cell.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        cell.lblViews.layer.cornerRadius = 10.0
        cell.lblViews.text = "        " + self.trendingWallpaperArr[indexPath.item]["wallpaper_views"]! + "  "
        cell.btnLike.layer.cornerRadius = 20.0
        cell.btnLike.tag = indexPath.item
        cell.btnLike.addTarget(self, action: #selector(self.btnLike_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlString = API_URL + "wallpaperview.php"
        let params: NSDictionary = ["wallpaper_id":self.trendingWallpaperArr[indexPath.item]["id"]!]
        self.Webservice_ViewWallpaper(url: urlString, params: params, wallpaperIndex: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.trendingWallpaperArr.count - 1 {
            if self.pageIndex != 0 {
                var userId = ""
                if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
                    userId = ""
                }
                else {
                    userId = UserDefaults.standard.value(forKey: UD_userId) as! String
                }
                let urlString = API_URL + "gettrendingwallpapers.php"
                let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
                    "numberOfRecords":numberOfRecords,
                    "user_id":userId]
                self.Webservice_TrendingWallpapers(url: urlString, params: params)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        let wallpaperHeight = Int(self.trendingWallpaperArr[indexPath.item]["wallpaper_height"]!)
        return CGFloat(wallpaperHeight!)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return "".heightForWidth(width: withWidth, font: UIFont.systemFont(ofSize: 0))
    }
}

//MARK: Webservices
extension TrendingWallpaperVC
{
    func Webservice_TrendingWallpapers(url:String, params:NSDictionary) -> Void {
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
                        self.trendingWallpaperArr.removeAll()
                    }
                    if responseData.count < numberOfRecords {
                        self.pageIndex = 0
                    }
                    else {
                        self.pageIndex = self.pageIndex + 1
                    }
                    for data in responseData {
                        let wallpaperObj = ["id":data["id"].stringValue,"wallpaper_image":data["wallpaper_image"].stringValue,"wallpaper_height":data["wallpaper_height"].stringValue,"wallpaper_color":data["wallpaper_color"].stringValue,"user_id":data["user_id"].stringValue,"user_image":data["user_image"].stringValue,"user_name":data["user_name"].stringValue,"wallpaper_likes":data["wallpaper_likes"].stringValue,"wallpaper_views":data["wallpaper_views"].stringValue,"category_name":data["category_name"].stringValue,"isFavourite":data["isFavourite"].stringValue]
                        self.trendingWallpaperArr.append(wallpaperObj)
                    }
                    self.collection_trendingwallpapers.reloadData()
                }
                else if responseCode == "0" {
                    if self.pageIndex == 1 {
                        self.trendingWallpaperArr.removeAll()
                    }
                    self.pageIndex = 0
                    self.collection_trendingwallpapers.reloadData()
                }
            }
        }
    }
    
    func Webservice_ViewWallpaper(url:String, params:NSDictionary, wallpaperIndex:IndexPath) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WallpaperPreviewVC") as! WallpaperPreviewVC
                objVC.wallpaperArr = self.trendingWallpaperArr
                objVC.wallpaperIndex = wallpaperIndex
                self.navigationController?.pushViewController(objVC, animated: true)
            }
        }
    }
    
    func Webservice_FavouriteUnfavouriteWallpaper(url:String, params:NSDictionary, wallpaperIndex:Int, isFavourite:String) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let wallpaperObj = ["id":self.trendingWallpaperArr[wallpaperIndex]["id"]!,"wallpaper_image":self.trendingWallpaperArr[wallpaperIndex]["wallpaper_image"]!,"wallpaper_height":self.trendingWallpaperArr[wallpaperIndex]["wallpaper_height"]!,"wallpaper_color":self.trendingWallpaperArr[wallpaperIndex]["wallpaper_color"]!,"user_id":self.trendingWallpaperArr[wallpaperIndex]["user_id"]!,"user_image":self.trendingWallpaperArr[wallpaperIndex]["user_image"]!,"user_name":self.trendingWallpaperArr[wallpaperIndex]["user_name"]!,"wallpaper_likes":self.trendingWallpaperArr[wallpaperIndex]["wallpaper_likes"]!,"wallpaper_views":self.trendingWallpaperArr[wallpaperIndex]["wallpaper_views"]!,"category_name":self.trendingWallpaperArr[wallpaperIndex]["category_name"]!,"isFavourite":isFavourite]
                    self.trendingWallpaperArr.remove(at: wallpaperIndex)
                    self.trendingWallpaperArr.insert(wallpaperObj, at: wallpaperIndex)
                    self.collection_trendingwallpapers.reloadData()
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["ResponseMessage"].stringValue)
                }
            }
        }
    }
}
