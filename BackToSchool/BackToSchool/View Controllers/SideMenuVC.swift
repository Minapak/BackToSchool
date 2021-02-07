//
//  SideMenuVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//


import UIKit
import SwiftyJSON
import SDWebImage

class MenuTableCell: UITableViewCell {
    
    @IBOutlet weak var lbl_menu: UILabel!
    @IBOutlet weak var img_menu: UIImageView!
}

class SideMenuVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var tbl_menu: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    
    //MARK: Variables
    var menuArray = ["수업 자료 홈","과목","내 수업자료","내가 업로드 한 자료","수업 영상 홈","설정"]
    var menuImgeArray = ["ic_home","ic_categories","ic_rating","ic_upload","ic_home","ic_settings"]
    var homeViewController = UINavigationController()
    var categoryViewController = UINavigationController()
    var favouriteViewController = UINavigationController()
    var myWallpaperViewController = UINavigationController()
    var tvViewController = UINavigationController()
    var settingsViewController = UINavigationController()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgProfile.layer.cornerRadius = 60.0
        
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        self.homeViewController = UINavigationController(rootViewController: homeVC)
        self.homeViewController.setNavigationBarHidden(true, animated: true)
        
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryVC") as! CategoryVC
        self.categoryViewController = UINavigationController(rootViewController: categoryVC)
        self.categoryViewController.setNavigationBarHidden(true, animated: true)
        
        let favouriteVC = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteVC1") as! FavouriteVC1
        self.favouriteViewController = UINavigationController(rootViewController: favouriteVC)
        self.favouriteViewController.setNavigationBarHidden(true, animated: true)
        
        let mywallpaperVC = self.storyboard?.instantiateViewController(withIdentifier: "MyWallpapersVC") as! MyWallpapersVC
        self.myWallpaperViewController = UINavigationController(rootViewController: mywallpaperVC)
        self.myWallpaperViewController.setNavigationBarHidden(true, animated: true)
        
        let TvVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.tvViewController = UINavigationController(rootViewController: TvVC)
        self.tvViewController.setNavigationBarHidden(true, animated: true)
        
        let settingsVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC1") as! SettingsVC1
        self.settingsViewController = UINavigationController(rootViewController: settingsVC)
        self.settingsViewController.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
            self.imgProfile.image = UIImage(named: "placeholder_image")
            self.lblUsername.text = Bundle.main.displayName!
        }
        else {
            let urlString = API_URL + "getprofile.php"
            let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String]
            self.Webservice_GetProfile(url: urlString, params: params)
        }
    }
    
}

//MARK: Tableview methods
extension SideMenuVC : UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell") as! MenuTableCell
        cell.lbl_menu.text = self.menuArray[indexPath.row]
        cell.img_menu.image = UIImage.init(named: self.menuImgeArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            self.slideMenuController()?.changeMainViewController(self.homeViewController, close: true)
        }
        if indexPath.row == 1
        {
            self.slideMenuController()?.changeMainViewController(self.categoryViewController, close: true)
        }
        if indexPath.row == 2
        {
            self.slideMenuController()?.changeMainViewController(self.favouriteViewController, close: true)
        }
        if indexPath.row == 3
        {
            self.slideMenuController()?.changeMainViewController(self.myWallpaperViewController, close: true)
        }
        if indexPath.row == 4
        {
            self.slideMenuController()?.changeMainViewController(self.tvViewController, close: true)
        }
        
        if indexPath.row == 5
        {
            self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
        }
       
    }
}

//MARK: Webservices
extension SideMenuVC {
    func Webservice_GetProfile(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:false, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let responseData = jsonResponse!["ResponseData"].dictionaryValue
                    self.imgProfile.sd_setImage(with: URL(string: responseData["profile_image"]!.stringValue), placeholderImage: UIImage(named: "placeholder_image"))
                    self.lblUsername.text = responseData["username"]?.stringValue
                }
            }
        }
    }
}
