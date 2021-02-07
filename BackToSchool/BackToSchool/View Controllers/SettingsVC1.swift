//
//  File.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import SwiftyJSON

class SettingsVC1: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewNotifications: UIView!
    @IBOutlet weak var viewChangePassword: UIView!
    @IBOutlet weak var viewPrivacy: UIView!
    @IBOutlet weak var viewAbout: UIView!
    @IBOutlet weak var viewBuild: UIView!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var switchNotification: UISwitch!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblVersion: UILabel!
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgProfile.layer.cornerRadius = 60.0
        self.viewNotifications.layer.cornerRadius = 5.0
        self.viewChangePassword.layer.cornerRadius = 5.0
        self.viewPrivacy.layer.cornerRadius = 5.0
        self.viewAbout.layer.cornerRadius = 5.0
        self.viewBuild.layer.cornerRadius = 5.0
        self.btnLogout.layer.cornerRadius = 8.0
        
        self.lblVersion.text = Bundle.main.releaseVersionNumber! + "(" + Bundle.main.buildVersionNumber! + ")"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        DispatchQueue.main.async {
            if UserDefaults.standard.value(forKey: UD_userId) == nil || UserDefaults.standard.value(forKey: UD_userId) as! String == "" || UserDefaults.standard.value(forKey: UD_userId) as! String == "N/A" || UserDefaults.standard.value(forKey: UD_userId) as! String == "0" {
                let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                let nav : UINavigationController = UINavigationController(rootViewController: objVC)
                nav.navigationBar.isHidden = true
                UIApplication.shared.windows[0].rootViewController = nav
            }
            else {
                let urlString = API_URL + "getprofile.php"
                let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String]
                self.Webservice_GetProfile(url: urlString, params: params)
            }
        }
    }
    
}

//MARK: Actions
extension SettingsVC1 {
    @IBAction func notificationSwitch_changed(_ sender: UISwitch) {
        if self.switchNotification.isOn == true {
            let urlString = API_URL + "notificationstatus.php"
            let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                        "status":"1"]
            self.Webservice_NotificationStatus(url: urlString, params: params, status: true)
        }
        else {
            let urlString = API_URL + "notificationstatus.php"
            let params: NSDictionary = ["user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                        "status":"2"]
            self.Webservice_NotificationStatus(url: urlString, params: params, status: false)
        }
    }
    
    @IBAction func btnEdit_Clicked(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func btnMenu_Clicked(_ sender: UIButton) {
        self.slideMenuController()?.openLeft()
    }
    
//    @IBAction func btnChangePassword_Clicked(_ sender: UIButton) {
//        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordRecoveryVC") as! PasswordRecoveryVC
//        self.navigationController?.pushViewController(objVC, animated: true)
//    }
    
    @IBAction func btnAbout_Clicked(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        objVC.isSelectedindex = "1"
        
        objVC.setTitle = "About Back To School"
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func btnPrivacyPolicy_Clicked(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WebviewVC") as! WebviewVC
        objVC.isSelectedindex = "0"
        objVC.setTitle = "약관"
        self.navigationController?.pushViewController(objVC, animated: true)
        
    }
    
    @IBAction func btnLogout_Clicked(_ sender: UIButton) {
        let alertVC = UIAlertController(title: Bundle.main.displayName!, message: "정말 로그아웃을 하시겠습니까?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "네", style: .default) { (action) in
            UserDefaults.standard.set("", forKey: UD_userId)
            let objVC = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
            let nav : UINavigationController = UINavigationController(rootViewController: objVC)
            nav.navigationBar.isHidden = true
            UIApplication.shared.windows[0].rootViewController = nav
        }
        let noAction = UIAlertAction(title: "아니오", style: .destructive)
        alertVC.addAction(yesAction)
        alertVC.addAction(noAction)
        self.present(alertVC, animated: true, completion: nil)
    }
}

//MARK: Webservices
extension SettingsVC1
{
    func Webservice_NotificationStatus(url:String, params:NSDictionary, status:Bool) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                self.switchNotification.isOn = status
            }
        }
    }
    func Webservice_GetProfile(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
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
                    self.lblEmail.text = responseData["email"]?.stringValue
                    if responseData["notification"]?.stringValue == "1" {
                        self.switchNotification.isOn = true
                    }
                    else {
                        self.switchNotification.isOn = false
                    }
                }
            }
        }
    }
}
