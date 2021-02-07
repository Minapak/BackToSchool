//
//  ForgetPasswordVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import SwiftyJSON

class ForgetPasswordVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var img_random: UIImageView!
    
    //MARK: Variables
    var imageTimer = Timer()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSubmit.layer.cornerRadius = 8.0
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
extension ForgetPasswordVC {
    @objc func changeImage() {
        let images: [UIImage] = [UIImage(named: "bts4_background")!,UIImage(named: "bts4_background")!,UIImage(named: "bts4_background")!,UIImage(named: "bts4_background")!,UIImage(named: "bts4_background")!]
        self.img_random.image = images.shuffled().randomElement()
    }
}

//MARK: Actions
extension ForgetPasswordVC {
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit_Clicked(_ sender: UIButton) {
        if self.txtEmail.text == "" {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Please enter your registered email address")
        }
        else if self.txtEmail.text!.isEmail == false {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "Please enter valid email address")
        }
        else {
            let urlString = API_URL + "forgetpassword.php"
            let params: NSDictionary = ["email":self.txtEmail.text!]
            self.Webservice_ForgetPassword(url: urlString, params: params)
        }
    }
}

//MARK: Webservices
extension ForgetPasswordVC
{
    func Webservice_ForgetPassword(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let alertVC = UIAlertController(title: Bundle.main.displayName!, message: jsonResponse!["ResponseMessage"].stringValue, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertVC.addAction(okAction)
                    self.present(alertVC, animated: true, completion: nil)
                }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["ResponseMessage"].stringValue)
                }
            }
        }
    }
}
