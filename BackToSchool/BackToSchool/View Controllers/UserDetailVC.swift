//
//  UserDetailVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//


import UIKit
import PinterestLayout
import SwiftyJSON
import GoogleMobileAds

class RelatedCollectionCell: UICollectionViewCell {
    
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

class UserDetailVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var viewUploads: UIView!
    @IBOutlet weak var viewViews: UIView!
    @IBOutlet weak var viewLikes: UIView!
    @IBOutlet weak var lblUploads: UILabel!
    @IBOutlet weak var lblViews: UILabel!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblMoreBy: UILabel!
    @IBOutlet weak var collection_relatedwallpapers: UICollectionView!
    @IBOutlet weak var view_BannerAd: UIView!
    @IBOutlet weak var viewBannerAd_height: NSLayoutConstraint!
    
    //MARK: Variables
    var relatedWallpaperArr = [[String:String]]()
    var pageIndex = 1
    private let refreshControl = UIRefreshControl()
    var userId = ""
    var bannerView: GADBannerView!
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgProfile.layer.cornerRadius = 50.0
        self.viewUploads.layer.cornerRadius = 5.0
        self.viewViews.layer.cornerRadius = 5.0
        self.viewLikes.layer.cornerRadius = 5.0
        
        let layout = PinterestLayout()
        self.collection_relatedwallpapers.collectionViewLayout = layout
        layout.delegate = self
        layout.numberOfColumns = 2
        
        self.collection_relatedwallpapers.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshWallpaperData(_:)), for: .valueChanged)
        
        var guestId = ""
        if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
            guestId = ""
        }
        else {
            guestId = UserDefaults.standard.value(forKey: UD_userId) as! String
        }
        let urlString = API_URL + "userprofile.php"
        let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
            "numberOfRecords":numberOfRecords,
            "user_id":self.userId,
            "guest_id":guestId]
        self.Webservice_UserDetail(url: urlString, params: params)
        
        self.viewBannerAd_height.constant = 0.0
        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerView.adUnitID = AdBannerIdTest
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
    }
    
}

//MARK: Functions
extension UserDetailVC {
    @objc private func refreshWallpaperData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        self.pageIndex = 1
        var guestId = ""
        if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
            guestId = ""
        }
        else {
            guestId = UserDefaults.standard.value(forKey: UD_userId) as! String
        }
        let urlString = API_URL + "userprofile.php"
        let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
            "numberOfRecords":numberOfRecords,
            "user_id":self.userId,
            "guest_id":guestId]
        self.Webservice_UserDetail(url: urlString, params: params)
    }
}

//MARK: Actions
extension UserDetailVC {
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnLike_Clicked(sender: UIButton) {
        if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            UIApplication.shared.windows[0].rootViewController = nav
        }
        else {
            if self.relatedWallpaperArr[sender.tag]["isFavourite"] == "2" {
                let urlString = API_URL + "favouriteunfavourite.php"
                let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                            "wallpaper_id":self.relatedWallpaperArr[sender.tag]["id"]!,
                                            "favourite":"1"]
                self.Webservice_FavouriteUnfavouriteWallpaper(url: urlString, params: params, wallpaperIndex: sender.tag, isFavourite: "1")
            }
            else {
                let urlString = API_URL + "favouriteunfavourite.php"
                let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                            "wallpaper_id":self.relatedWallpaperArr[sender.tag]["id"]!,
                                            "favourite":"2"]
                self.Webservice_FavouriteUnfavouriteWallpaper(url: urlString, params: params, wallpaperIndex: sender.tag, isFavourite: "2")
            }
        }
    }
}

//MARK: Collectionview methods
extension UserDetailVC: UICollectionViewDelegate,UICollectionViewDataSource,PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.collection_relatedwallpapers.bounds.size.width, height: self.collection_relatedwallpapers.bounds.size.height))
        let noDataImage = UIImageView(frame: rect)
        noDataImage.contentMode = .scaleAspectFit
        noDataImage.image = UIImage(named: "ic_noData")
        self.collection_relatedwallpapers.backgroundView = noDataImage
        if self.relatedWallpaperArr.count == 0 {
            noDataImage.isHidden = false
        }
        else {
            noDataImage.isHidden = true
        }
        return self.relatedWallpaperArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_relatedwallpapers.dequeueReusableCell(withReuseIdentifier: "RelatedCollectionCell", for: indexPath) as! RelatedCollectionCell
        cell.backgroundColor = UIColor.init(hex: self.relatedWallpaperArr[indexPath.item]["wallpaper_color"]!)
        cell.imgWallpaper.isHidden = true
        cell.imgWallpaper.sd_setImage(with: URL(string: self.relatedWallpaperArr[indexPath.item]["wallpaper_image"]!)) { (image, error, cache, url) in
            cell.imgWallpaper.isHidden = false
        }
        if self.relatedWallpaperArr[indexPath.item]["isFavourite"] == "2" {
            cell.btnLike.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        else {
            cell.btnLike.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        cell.lblViews.layer.cornerRadius = 10.0
        cell.lblViews.text = "        " + self.relatedWallpaperArr[indexPath.item]["wallpaper_views"]! + "  "
        cell.btnLike.layer.cornerRadius = 20.0
        cell.btnLike.tag = indexPath.item
        cell.btnLike.addTarget(self, action: #selector(self.btnLike_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlString = API_URL + "wallpaperview.php"
        let params: NSDictionary = ["wallpaper_id":self.relatedWallpaperArr[indexPath.item]["id"]!]
        self.Webservice_ViewWallpaper(url: urlString, params: params, wallpaperIndex: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.relatedWallpaperArr.count - 1 {
            if self.pageIndex != 0 {
                var guestId = ""
                if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
                    guestId = ""
                }
                else {
                    guestId = UserDefaults.standard.value(forKey: UD_userId) as! String
                }
                let urlString = API_URL + "userprofile.php"
                let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
                    "numberOfRecords":numberOfRecords,
                    "user_id":self.userId,
                    "guest_id":guestId]
                self.Webservice_UserDetail(url: urlString, params: params)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        let wallpaperHeight = Int(self.relatedWallpaperArr[indexPath.item]["wallpaper_height"]!)
        return CGFloat(wallpaperHeight!)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return "".heightForWidth(width: withWidth, font: UIFont.systemFont(ofSize: 0))
    }
}

//MARK: Webservices
extension UserDetailVC
{
    func Webservice_UserDetail(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let responseData = jsonResponse!["ResponseData"].dictionaryValue
                    let relatedData = responseData["related_wallpapers"]?.arrayValue
                    if self.pageIndex == 1 {
                        self.relatedWallpaperArr.removeAll()
                        self.imgProfile.sd_setImage(with: URL(string: responseData["user_image"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
                        self.lblUsername.text = responseData["user_name"]?.stringValue
                        self.lblMoreBy.text = "More By " + responseData["user_name"]!.stringValue
                        self.lblUploads.text = responseData["total_wallpapers"]?.stringValue
                        self.lblViews.text = responseData["total_views"]?.stringValue
                        self.lblLikes.text = responseData["total_likes"]?.stringValue
                    }
                    if responseData.count < numberOfRecords {
                        self.pageIndex = 0
                    }
                    else {
                        self.pageIndex = self.pageIndex + 1
                    }
                    for data in relatedData! {
                        let wallpaperObj = ["id":data["id"].stringValue,"wallpaper_image":data["wallpaper_image"].stringValue,"wallpaper_height":data["wallpaper_height"].stringValue,"wallpaper_color":data["wallpaper_color"].stringValue,"user_id":data["user_id"].stringValue,"user_image":data["user_image"].stringValue,"user_name":data["user_name"].stringValue,"wallpaper_likes":data["wallpaper_likes"].stringValue,"wallpaper_views":data["wallpaper_views"].stringValue,"category_name":data["category_name"].stringValue,"isFavourite":data["isFavourite"].stringValue]
                        self.relatedWallpaperArr.append(wallpaperObj)
                    }
                    self.collection_relatedwallpapers.reloadData()
                }
                else if responseCode == "0" {
                    self.pageIndex = 0
                    self.collection_relatedwallpapers.reloadData()
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
                objVC.wallpaperArr = self.relatedWallpaperArr
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
                    let wallpaperObj = ["id":self.relatedWallpaperArr[wallpaperIndex]["id"]!,"wallpaper_image":self.relatedWallpaperArr[wallpaperIndex]["wallpaper_image"]!,"wallpaper_height":self.relatedWallpaperArr[wallpaperIndex]["wallpaper_height"]!,"wallpaper_color":self.relatedWallpaperArr[wallpaperIndex]["wallpaper_color"]!,"user_id":self.relatedWallpaperArr[wallpaperIndex]["user_id"]!,"user_image":self.relatedWallpaperArr[wallpaperIndex]["user_image"]!,"user_name":self.relatedWallpaperArr[wallpaperIndex]["user_name"]!,"wallpaper_likes":self.relatedWallpaperArr[wallpaperIndex]["wallpaper_likes"]!,"wallpaper_views":self.relatedWallpaperArr[wallpaperIndex]["wallpaper_views"]!,"category_name":self.relatedWallpaperArr[wallpaperIndex]["category_name"]!,"isFavourite":isFavourite]
                    self.relatedWallpaperArr.remove(at: wallpaperIndex)
                    self.relatedWallpaperArr.insert(wallpaperObj, at: wallpaperIndex)
                    self.collection_relatedwallpapers.reloadData()
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["ResponseMessage"].stringValue)
                }
            }
        }
    }
}

//MARK: Admob methods
extension UserDetailVC: GADBannerViewDelegate {
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        self.bannerView.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 50.0)
        self.view_BannerAd.addSubview(self.bannerView)
        self.viewBannerAd_height.constant = 50.0
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        self.viewBannerAd_height.constant = 0.0
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
