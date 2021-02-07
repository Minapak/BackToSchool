//
//  RegisterVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import SwiftyJSON
import Alamofire
import MBProgressHUD
import SlideMenuControllerSwift

class RegisterVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var img_random: UIImageView!
    
    //MARK: Variables
    var imageTimer = Timer()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnRegister.layer.cornerRadius = 8.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.changeImage()
        self.imageTimer.invalidate()
        self.imageTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.imageTimer.invalidate()
    }
    
}

//MARK: Actions
extension RegisterVC {
    @IBAction func btnRegister_Clicked(_ sender: UIButton) {
        if self.txtUsername.text == "" || self.txtEmail.text == "" || self.txtPassword.text == "" || self.txtConfirmPassword.text == "" {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Please enter all details")
        }
        else if self.txtEmail.text!.isEmail == false {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Please enter valid email address")
        }
        else if self.txtPassword.text!.count < 8 {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Password must be minimum 8 characters")
        }
        else if self.txtPassword.text! != self.txtConfirmPassword.text {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Password & Confirm password must be same")
        }
        else {
            let urlString = API_URL + "register.php"
            let params: NSDictionary = ["username":self.txtUsername.text!,
                                        "email":self.txtEmail.text!,
                                        "password":self.txtPassword.text!,
                                        "device_type":"2",
                                        "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
            self.Webservice_Register(url: urlString, params: params)
        }
    }
    
    @IBAction func btnLogin_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: Functions
extension RegisterVC {
    @objc func changeImage() {
        let images: [UIImage] = [UIImage(named: "ic_background1")!,UIImage(named: "ic_background1")!,UIImage(named: "ic_background1")!,UIImage(named: "ic_background1")!,UIImage(named: "ic_background1")!]
        self.img_random.image = images.shuffled().randomElement()
    }
}

//MARK: Webservices
extension RegisterVC
{
    func Webservice_Register(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let responseData = jsonResponse!["ResponseData"].dictionaryValue
                    let userId = responseData["id"]?.stringValue
                    UserDefaultManager.setStringToUserDefaults(value: userId!, key: UD_userId)
                    //유저 이름 저장
                    UserDefaultManager.setStringToUserDefaults(value:  self.txtUsername.text!, key: UD_userName)
                    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
                    let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
                    appNavigation.setNavigationBarHidden(true, animated: true)
                    let slideMenuController = SlideMenuController(mainViewController: appNavigation, leftMenuViewController: sideMenuViewController)
                    slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width * 0.8)
                    slideMenuController.removeLeftGestures()
                    UIApplication.shared.windows[0].rootViewController = slideMenuController
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["ResponseMessage"].stringValue)
                }
            }
        }
    }
}
