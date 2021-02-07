//
//  HomeVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import GoogleMobileAds

class HomeVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var pagerView: UIView!
    @IBOutlet weak var view_BannerAd: UIView!
    @IBOutlet weak var viewBannerAd_height: NSLayoutConstraint!
    
    //MARK: Variables
    var tabs = [ViewPagerTab(title: "최근 자료", image: UIImage(named: "")),
                ViewPagerTab(title: "인기 자료", image: UIImage(named: ""))]
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    var bannerView: GADBannerView!
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pagerRect : CGRect!
        if UIScreen.main.bounds.height >= 812.0 {
            pagerRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 122)
        }
        else {
            pagerRect = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        }
        self.options = ViewPagerOptions(viewPagerWithFrame:pagerRect)
        self.options.tabType = ViewPagerTabType.basic
        self.options.tabViewTextFont = UIFont.boldSystemFont(ofSize: 15.0)
        self.options.isTabHighlightAvailable = true
        self.viewPager = ViewPagerController()
        self.viewPager.options = options
        self.viewPager.dataSource = self
        self.viewPager.delegate = self
        self.addChild(self.viewPager)
        self.pagerView.addSubview(self.viewPager.view)
        self.viewPager.didMove(toParent: self)
        
        self.viewBannerAd_height.constant = 0.0
        self.bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        self.bannerView.adUnitID = AdBannerIdTest
        self.bannerView.rootViewController = self
        self.bannerView.delegate = self
        self.bannerView.load(GADRequest())
    }
    
}

//MARK: Actions
extension HomeVC {
    @IBAction func btnMenu_Clicked(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
}

//MARK: Pagerview methods
extension HomeVC: ViewPagerControllerDataSource,ViewPagerControllerDelegate {
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        if position == 0
        {
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "LatestWallpaperVC") as! LatestWallpaperVC
            return objVC
        }
        else
        {
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "TrendingWallpaperVC") as! TrendingWallpaperVC
            return objVC
        }
    }
    
    func tabsForPages() -> [ViewPagerTab] {
        return tabs
    }
    
    func startViewPagerAtIndex() -> Int {
        return 0
    }
    
    func willMoveToControllerAtIndex(index:Int) {
        print("Moving to page \(index)")
    }
    
    func didMoveToControllerAtIndex(index: Int) {
        print("Moved to page \(index)")
    }
}

//MARK: Admob methods
extension HomeVC: GADBannerViewDelegate {
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
