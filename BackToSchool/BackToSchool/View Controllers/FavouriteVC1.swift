//
//  FavouriteVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import PinterestLayout
import SwiftyJSON
import GoogleMobileAds

class FavouriteCollectionCell: UICollectionViewCell {
    
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

class FavouriteVC1: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collection_favouritewallpapers: UICollectionView!
    @IBOutlet weak var view_BannerAd: UIView!
    @IBOutlet weak var viewBannerAd_height: NSLayoutConstraint!
    
    //MARK: Variables
    var favouriteWallpaperArr = [[String:String]]()
    var pageIndex = 1
    private let refreshControl = UIRefreshControl()
    var bannerView: GADBannerView!
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = PinterestLayout()
        self.collection_favouritewallpapers.collectionViewLayout = layout
        layout.delegate = self
        layout.numberOfColumns = 2
        
        DispatchQueue.main.async {
            if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                UIApplication.shared.windows[0].rootViewController = nav
            }
            else {
                self.collection_favouritewallpapers.refreshControl = self.refreshControl
                self.refreshControl.addTarget(self, action: #selector(self.refreshWallpaperData(_:)), for: .valueChanged)
                
                let urlString = API_URL + "getfavouritewallpapers.php"
                let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
                    "numberOfRecords":numberOfRecords,
                    "user_id":UserDefaults.standard.value(forKey: UD_userId) as! String]
                self.Webservice_FavouriteWallpapers(url: urlString, params: params)
            }
        }
        
        self.viewBannerAd_height.constant = 0.0
        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerView.adUnitID = AdBannerIdTest
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
    }
    
}

//MARK: Functions
extension FavouriteVC1 {
    @objc private func refreshWallpaperData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        self.pageIndex = 1
        let urlString = API_URL + "getfavouritewallpapers.php"
        let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
            "numberOfRecords":numberOfRecords,"user_id":UserDefaults.standard.value(forKey: UD_userId) as! String]
        self.Webservice_FavouriteWallpapers(url: urlString, params: params)
    }
}

//MARK: Actions
extension FavouriteVC1 {
    @IBAction func btnMenu_Clicked(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    
    @objc func btnLike_Clicked(sender: UIButton) {
        let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "Are you sure to remove this wallpaper from your favourites?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let urlString = API_URL + "favouriteunfavourite.php"
            let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                        "wallpaper_id":self.favouriteWallpaperArr[sender.tag]["id"]!,
                                        "favourite":"2"]
            self.Webservice_UnfavouriteWallpaper(url: urlString, params: params, wallpaperIndex: sender.tag)
        }
        let noAction = UIAlertAction(title: "No", style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

//MARK: Collectionview methods
extension FavouriteVC1: UICollectionViewDelegate,UICollectionViewDataSource,PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 50.0, height: 50.0))
        let noDataImage = UIImageView(frame: rect)
        noDataImage.center = self.collection_favouritewallpapers.center
        noDataImage.contentMode = .scaleAspectFit
        noDataImage.image = UIImage(named: "ic_noData")
        self.collection_favouritewallpapers.backgroundView = noDataImage
        if self.favouriteWallpaperArr.count == 0 {
            noDataImage.isHidden = false
        }
        else {
            noDataImage.isHidden = true
        }
        return self.favouriteWallpaperArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_favouritewallpapers.dequeueReusableCell(withReuseIdentifier: "FavouriteCollectionCell", for: indexPath) as! FavouriteCollectionCell
        cell.backgroundColor = UIColor.init(hex: self.favouriteWallpaperArr[indexPath.item]["wallpaper_color"]!)
        cell.imgWallpaper.isHidden = true
        cell.imgWallpaper.sd_setImage(with: URL(string: self.favouriteWallpaperArr[indexPath.item]["wallpaper_image"]!)) { (image, error, cache, url) in
            cell.imgWallpaper.isHidden = false
        }
        cell.lblViews.layer.cornerRadius = 10.0
        cell.lblViews.text = "        " + self.favouriteWallpaperArr[indexPath.item]["wallpaper_views"]! + "  "
        cell.btnLike.layer.cornerRadius = 20.0
        cell.btnLike.tag = indexPath.item
        cell.btnLike.addTarget(self, action: #selector(self.btnLike_Clicked(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let urlString = API_URL + "wallpaperview.php"
        let params: NSDictionary = ["wallpaper_id":self.favouriteWallpaperArr[indexPath.item]["id"]!]
        self.Webservice_ViewWallpaper(url: urlString, params: params, wallpaperIndex: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.favouriteWallpaperArr.count - 1 {
            if self.pageIndex != 0 {
                let urlString = API_URL + "getfavouritewallpapers.php"
                let params: NSDictionary = ["pageIndex":"\(self.pageIndex)",
                    "numberOfRecords":numberOfRecords,"user_id":UserDefaults.standard.value(forKey: UD_userId) as! String]
                self.Webservice_FavouriteWallpapers(url: urlString, params: params)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForImageAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        let wallpaperHeight = Int(self.favouriteWallpaperArr[indexPath.item]["wallpaper_height"]!)
        return CGFloat(wallpaperHeight!)
    }
    
    func collectionView(collectionView: UICollectionView,
                        heightForAnnotationAtIndexPath indexPath: IndexPath,
                        withWidth: CGFloat) -> CGFloat {
        return "".heightForWidth(width: withWidth, font: UIFont.systemFont(ofSize: 0))
    }
}

//MARK: Webservices
extension FavouriteVC1
{
    func Webservice_FavouriteWallpapers(url:String, params: NSDictionary) -> Void {
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
                        self.favouriteWallpaperArr.removeAll()
                    }
                    if responseData.count < numberOfRecords {
                        self.pageIndex = 0
                    }
                    else {
                        self.pageIndex = self.pageIndex + 1
                    }
                    for data in responseData {
                        let wallpaperObj = ["id":data["id"].stringValue,"wallpaper_image":data["wallpaper_image"].stringValue,"wallpaper_height":data["wallpaper_height"].stringValue,"wallpaper_color":data["wallpaper_color"].stringValue,"user_id":data["user_id"].stringValue,"user_image":data["user_image"].stringValue,"user_name":data["user_name"].stringValue,"wallpaper_likes":data["wallpaper_likes"].stringValue,"wallpaper_views":data["wallpaper_views"].stringValue,"category_name":data["category_name"].stringValue]
                        self.favouriteWallpaperArr.append(wallpaperObj)
                    }
                    self.collection_favouritewallpapers.reloadData()
                }
                else if responseCode == "0" {
                    if self.pageIndex == 1 {
                        self.favouriteWallpaperArr.removeAll()
                    }
                    self.pageIndex = 0
                    self.collection_favouritewallpapers.reloadData()
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
                objVC.wallpaperArr = self.favouriteWallpaperArr
                objVC.wallpaperIndex = wallpaperIndex
                self.navigationController?.pushViewController(objVC, animated: true)
            }
        }
    }
    
    func Webservice_UnfavouriteWallpaper(url:String, params:NSDictionary, wallpaperIndex:Int) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    self.favouriteWallpaperArr.remove(at: wallpaperIndex)
                    self.collection_favouritewallpapers.reloadData()
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["ResponseMessage"].stringValue)
                }
            }
        }
    }
}

//MARK: Admob methods
extension FavouriteVC1: GADBannerViewDelegate {
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

