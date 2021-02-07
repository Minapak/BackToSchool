//
//  CategoryVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import SwiftyJSON
import GoogleMobileAds

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
}

class CategoryVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var collection_category: UICollectionView!
    @IBOutlet weak var view_BannerAd: UIView!
    @IBOutlet weak var viewBannerAd_height: NSLayoutConstraint!
    
    //MARK: Variables
    var categoryArr = [[String:String]]()
    var bannerView: GADBannerView!
    private let refreshControl = UIRefreshControl()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collection_category.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.refreshWallpaperData(_:)), for: .valueChanged)
        
        let urlString = API_URL + "getcategories.php"
        self.Webservice_Categories(url: urlString)
        
        self.viewBannerAd_height.constant = 0.0
        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerView.adUnitID = AdBannerIdTest
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
    }
    
}

//MARK: Functions
extension CategoryVC {
    @objc private func refreshWallpaperData(_ sender: Any) {
        self.refreshControl.endRefreshing()
        let urlString = API_URL + "getcategories.php"
        self.Webservice_Categories(url: urlString)
    }
}

//MARK: Actions
extension CategoryVC {
    @IBAction func btnMenu_Clicked(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
}

//MARK: Collectionview methods
extension CategoryVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rect = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.collection_category.bounds.size.width, height: self.collection_category.bounds.size.height))
        let noDataImage = UIImageView(frame: rect)
        noDataImage.contentMode = .scaleAspectFit
        noDataImage.image = UIImage(named: "ic_noData")
        self.collection_category.backgroundView = noDataImage
        if self.categoryArr.count == 0 {
            noDataImage.isHidden = false
        }
        else {
            noDataImage.isHidden = true
        }
        return self.categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection_category.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as! CategoryCollectionCell
        cell.imgCategory.layer.cornerRadius = ((UIScreen.main.bounds.width/2) - 32.0)/2
        cell.imgCategory.sd_setImage(with: URL(string: self.categoryArr[indexPath.item]["category_image"]!), placeholderImage: UIImage(named: "placeholder_image"))
        cell.lblCategory.text = self.categoryArr[indexPath.item]["category_name"]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2, height: (UIScreen.main.bounds.width/2) + 21)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WallpaperVC") as! WallpaperVC
        objVC.categoryId = self.categoryArr[indexPath.item]["id"]!
        objVC.categoryName = self.categoryArr[indexPath.item]["category_name"]!
        self.navigationController?.pushViewController(objVC, animated: true)
    }
}

//MARK: Webservices
extension CategoryVC
{
    func Webservice_Categories(url:String) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:[:], httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let responseData = jsonResponse!["ResponseData"].arrayValue
                    self.categoryArr.removeAll()
                    for data in responseData {
                        let categoryObj = ["id":data["id"].stringValue,"category_image":data["category_image"].stringValue,"category_name":data["category_name"].stringValue]
                        self.categoryArr.append(categoryObj)
                    }
                    self.collection_category.reloadData()
                }
            }
        }
    }
}

//MARK: Admob methods
extension CategoryVC: GADBannerViewDelegate {
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
