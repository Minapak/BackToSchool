//
//  MyWallpapersVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//
import UIKit

class MyWallpapersVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var pagerView: UIView!
    
    //MARK: Variables
    var tabs = [ViewPagerTab(title: "승인대기", image: UIImage(named: "")),
                ViewPagerTab(title: "승인완료", image: UIImage(named: "")),
                ViewPagerTab(title: "차단", image: UIImage(named: ""))]
    var viewPager:ViewPagerController!
    var options:ViewPagerOptions!
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                UIApplication.shared.windows[0].rootViewController = nav
            }
            else {
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
                self.viewPager.options = self.options
                self.viewPager.dataSource = self
                self.viewPager.delegate = self
                self.addChild(self.viewPager)
                self.pagerView.addSubview(self.viewPager.view)
                self.viewPager.didMove(toParent: self)
            }
        }
    }
    
}

//MARK: Pagerview methods
extension MyWallpapersVC: ViewPagerControllerDataSource,ViewPagerControllerDelegate {
    func numberOfPages() -> Int {
        return tabs.count
    }
    
    func viewControllerAtPosition(position:Int) -> UIViewController {
        if position == 0
        {
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PendingVC") as! PendingVC
            return objVC
        }
        else if position == 1
        {
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ApprovedVC") as! ApprovedVC
            return objVC
        }
        else
        {
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "RejectedVC") as! RejectedVC
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

//MARK: Actions
extension MyWallpapersVC {
    @IBAction func btnMenu_Clicked(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func btnAdd_Clicked(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "AddWallpaperVC") as! AddWallpaperVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
}
