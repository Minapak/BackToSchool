//
//  ChangePasswordVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import SwiftyJSON
import LGButton
import SwiftValidator

class ChangePasswordVC: UIViewController, ValidationDelegate{
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
    
    }
    

    
    let validator = Validator()
    //MARK: Outlets
    @IBOutlet weak var btnSubmit: LGButton!
   // @IBOutlet weak var txtOldpassword: UITextField!
    @IBOutlet weak var txtNewpassword: UITextField!
    @IBOutlet weak var txtConfirmpassword: UITextField!
    
    
    var email = ""
    var verificationTokenFromServer = ""
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
     //   self.initValidatorStyleTransformers()
     //   registerTextField()
        self.btnSubmit.layer.cornerRadius = 8.0
    }
    func updatePassword(email: String,verificationToken: String, password: String){

        ///async / sync
        ///sync : 동기 처리 메소드
        ///해당 작업을 처리하는 동안 다음으로 진행되지 않고 계속 머무름
        ///
        ///async : 비동기 처리 메소드
        ///처리를 하라고 지시후 다음으로 넘어감
        DispatchQueue.global().async {
            VideonManager.shared().updatePassword(emailValue: email,verificationTokenValue: verificationToken ,passwordValue: password)
            { (response, message) in

                DispatchQueue.main.async {
                    if response != nil {
                        if (response.status == 200)
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                            self.navigationController?.pushViewController(vc, animated: true)

                        }
                        else {
                            self.showToast(message: response.message)
                        }

                    } else {
                        self.showToast(message: "Opps! something went wrong")

                    }

                }
            }
        }
    }
    func validationSuccessful() {
        // submit the form
        self.updatePassword(email: email, verificationToken: verificationTokenFromServer, password: txtNewpassword.text ?? "")    }
    }
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {

    }
    
    


//MARK: Actions
extension ChangePasswordVC {
    @IBAction func btnBack_Clicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    


  
    
    
    @IBAction func btnSubmit_Clicked(_ sender: UIButton) {
        if self.txtNewpassword.text == "" || self.txtConfirmpassword.text == "" {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "모든 칸을 채워주세요!")
        }
        else if self.txtNewpassword.text!.count < 8 {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "비밀번호는 최소 8자리 입니다!")
        }
        else if self.txtNewpassword.text! != self.txtConfirmpassword.text! {
            showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: "비밀번호와 비밀번호 확인칸이 맞지않습니다!")
        }
        else {
            
          
            print("submit button pressed")
            print("Validating...")
            validator.validate(self)
            let urlString = API_URL + "changepassword.php"
            let params: NSDictionary = [
                //"user_id":UserDefaults.standard.value(forKey: UD_userId) as! String,
                                        "user_id":email as! String,
                                      //  "oldpassword":self.txtOldpassword.text!,
                                        "newpassword":self.txtNewpassword.text!]
            self.Webservice_ChangePassword(url: urlString, params: params)
        }
    }
}


//MARK: Webservices
extension ChangePasswordVC
{
    func Webservice_ChangePassword(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                if responseCode == "1" {
                    let alertVC = UIAlertController(title: Bundle.main.displayName!, message: jsonResponse!["ResponseMessage"].stringValue, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
//                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
//                        self.navigationController?.pushViewController(vc, animated: true)
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

