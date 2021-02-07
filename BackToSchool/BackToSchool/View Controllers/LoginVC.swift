//
//  LoginVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import SwiftyJSON
import SlideMenuControllerSwift

class LoginVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var img_random: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    //MARK: Variables
    var imageTimer = Timer()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnLogin.layer.cornerRadius = 8.0
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

//MARK: Functions
extension LoginVC {
    @objc func changeImage() {
        let images: [UIImage] = [UIImage(named: "bts3_background")!,UIImage(named: "bts3_background")!,UIImage(named: "bts3_background")!,UIImage(named: "bts3_background")!,UIImage(named: "bts3_background")!]
        self.img_random.image = images.shuffled().randomElement()
    }
}

//MARK: Actions
extension LoginVC {
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnForgetPassword_Clicked(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordVC") as! ForgetPasswordVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func btnLogin_Clicked(_ sender: UIButton) {
        if self.txtEmail.text == "" || self.txtPassword.text == "" {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "모든 칸을 채워주세요!")
        }
        else if self.txtEmail.text!.isEmail == false {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "유효한 이메일을 적어주세요!")
        }
        else {
            let urlString = API_URL + "login.php"
            let params: NSDictionary = ["email":self.txtEmail.text!,
                                        "password":self.txtPassword.text!,
                                        "device_type":"2",
                                        "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
            self.Webservice_Login(url: urlString, params: params)
        }
    }
    @IBAction func btnRegister_Clicked(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
}

//MARK: Webservices
extension LoginVC
{
    func Webservice_Login(url:String, params:NSDictionary) -> Void {
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
