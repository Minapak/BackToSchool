//
//  CreatePasswordVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//
import UIKit
import SwiftValidator
import SwiftyJSON

class CreatePasswordVC: UIViewController, ValidationDelegate {
    let validator = Validator()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    @IBAction func sibmitButtonAction(_ sender: Any) {
        print("보내기 버튼 클릭")
        print("검증중,,,")
        validator.validate(self)
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var email = ""
    var verificationTokenFromServer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initValidatorStyleTransformers()
        registerTextField()
    }
    
    func registerTextField() {
        
        validator.registerField(passwordTextField, errorLabel: passwordErrorLabel, rules: [RequiredRule(), MinLengthRule(length: 2)])
        
        validator.registerField(confirmPasswordTextField, errorLabel: confirmPasswordErrorLabel, rules: [RequiredRule(),ConfirmationRule(confirmField: passwordTextField)])
    }
    
    func initValidatorStyleTransformers(){
        validator.styleTransformers(success:{ (validationRule) -> Void in
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
            } else if let textField = validationRule.field as? UITextView {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
            }
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            } else if let textField = validationError.field as? UITextView {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
    }

    func validationSuccessful() {
        // submit the form
        self.updatePassword(email: email, verificationToken: verificationTokenFromServer, password: passwordTextField.text ?? "")
        //수업자료 부분
        let urlString = API_URL + "changepassword.php"
        let params: NSDictionary = ["user_id":email,
                            
                                    "newpassword":self.passwordTextField.text!]
        
        self.Webservice_ChangePassword(url: urlString, params: params)
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        
    }
    
    
    
    func updatePassword(email: String,verificationToken: String, password: String){
        DispatchQueue.global().async {
            VideonManager.shared().updatePassword(emailValue: email,verificationTokenValue: verificationToken, passwordValue: password){ (response, message) in
                
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
}
//MARK: Webservices
extension CreatePasswordVC
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
