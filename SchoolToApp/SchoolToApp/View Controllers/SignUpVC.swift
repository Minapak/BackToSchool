//
//  SignUpVC.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit
import SwiftValidator
import SimpleCheckbox
import Firebase
import LGButton
import ZKProgressHUD

class SignUpVC: UIViewController, ValidationDelegate {
    let validator = Validator()
    
    @IBOutlet weak var signUpTitleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var youAgreeLabel: UILabel!
    
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var alreadyHaveAccountLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    @IBOutlet weak var signUpButton: LGButton!
    @IBOutlet weak var checkBox: Checkbox!
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signInButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // Text fields
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    
    // Error labels
    @IBOutlet weak var userNameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPassErrorLabel: UILabel!
    
    
    @IBAction func signUpButtonAction(_ sender: Any) {
        print("Validating...")
        validator.validate(self)
        
    }
    @IBAction func privacyPolicyButtonAction(_ sender: Any) {
        // WebVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        vc.pageTitle = "Privacy & policy"
        vc.htmlFileName = "privacy-policy"
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValidatorStyleTransformers()
        registerTextField()
        initCheckBoxUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
    }
    func changeLanguage()
    {
        let languageCode = AppUtils.getAppLanguage()
        print("Selected App Language Code: \(languageCode)")
        
        self.signUpTitleLabel.text = "signUpKey".localizableString(loc: languageCode)
        self.userNameLabel.text = "userNameKey".localizableString(loc: languageCode)
        self.emailLabel.text = "emailKey".localizableString(loc: languageCode)
        self.passwordLabel.text = "passwordKey".localizableString(loc: languageCode)
        self.confirmPasswordLabel.text = "confirmPasswordKey".localizableString(loc: languageCode)
        self.youAgreeLabel.text = "youAgreeKey".localizableString(loc: languageCode)
        self.privacyPolicyButton.setTitle("privacyPolicyKey".localizableString(loc: languageCode), for: .normal)
        self.signUpButton.titleString = "signUpKey".localizableString(loc: languageCode)
        self.alreadyHaveAccountLabel.text = "alreadyHaveAccountKey".localizableString(loc: languageCode)
        self.signInButton.setTitle("SignInKey".localizableString(loc: languageCode), for: .normal)
        
    }
    
    func initValidatorStyleTransformers(){
        validator.styleTransformers(success:{ (validationRule) -> Void in
            //print("here")
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
    
    
    func initCheckBoxUI(){
        // Chech box configuration
        checkBox.tintColor = .orange
        checkBox.borderStyle = .square
        checkBox.checkmarkStyle = .tick
        checkBox.uncheckedBorderColor = .black
        checkBox.checkedBorderColor = .red
        checkBox.borderLineWidth = 2
        checkBox.isChecked = false
        checkBox.checkboxFillColor = .white
        checkBox.checkmarkColor = .orange
        checkBox.valueChanged = { (value) in
            print("squarebox value change: \(value)")
            if(value){
                
            } else {
                
            }
        }
    }
    
    
    func registerTextField() {
        
        validator.registerField(userNameTextField, errorLabel: userNameErrorLabel, rules: [RequiredRule(), MinLengthRule(length: 2)])
        validator.registerField(emailTextField, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule(message: "Invalid email address")])
        validator.registerField(passwordTextField, errorLabel: passwordErrorLabel, rules: [RequiredRule(), MinLengthRule(length: 2)])
        validator.registerField(confirmPassTextField, errorLabel: confirmPassErrorLabel, rules: [RequiredRule(),ConfirmationRule(confirmField: passwordTextField)])
    }
    // ValidationDelegate methods
    
    func validationSuccessful() {
        // submit the form
        if(checkBox.isChecked)
        {
            // Videon Server Sign Up:
            // Email : 1 Google : 2 Facebook : 3
            // Social ID will be empty for Email, only applied for fb and google
            doSignUp(registrationType: 1, socialId: "", userName: self.userNameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!)
        } else {
            showAlertDialog(title: "Warning!", message: "Please agree privacy policy berofe sign up.")
        }
        
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        
    }
    
    func firebaseSignUpUsingEmailPassword(email:String, password:String){
        
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    self.showAlertDialog(title: "Error!", message: "The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.")
                    
                case .emailAlreadyInUse:
                    // Error: The email address is already in use by another account.
                    self.showAlertDialog(title: "Error!", message: "The email address is already in use by another account.")
                    
                case .invalidEmail:
                    // Error: The email address is badly formatted.
                    self.showAlertDialog(title: "Error!", message: "The email address is badly formatted.")
                    
                case .weakPassword:
                    // Error: The password must be 6 characters long or more.
                    self.showAlertDialog(title: "Error!", message: "The password must be 6 characters long or more.")
                    
                default:
                    print("Error: \(error.localizedDescription)")
                    
                }
            } else {
                print("User signs up successfully")
                let newUserInfo = Auth.auth().currentUser
                let email = newUserInfo?.email
                self.showToast(message: "User signs up successfully")
                
            }
        }
        
    }
    
    
    
    
    func doSignUp(registrationType: Int, socialId:String, userName: String, email:String, password:String){
        ZKProgressHUD.show("Please wait...")
        DispatchQueue.global().async {
            VideonManager.shared().signUp(registrationType: registrationType, socialIdValue: socialId, nameValue: userName, emailValue: email, passwordValue: password) { (response, message) in
                
                DispatchQueue.main.async {
                    
                    ZKProgressHUD.dismiss()
                    if response != nil {
                        print("doSignUp: Received Responce: \(response)")
                        if(response.status == 200){
                            // Parsing the data:
                            if let userMap = response.data as? [String : Any] {
                                let regisType = userMap[AppConstants.ServerKey.TYPE] as? String
                                if(regisType == "1"){
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "EMailVerificationVC") as! EMailVerificationVC
                                    vc.email = email
                                    self.navigationController?.pushViewController(vc, animated: true)
                                    
                                } else {
                                    var user = UserModel.init()
                                    user.id = userMap[AppConstants.ServerKey.ID] as? String ?? ""
                                    user.email = userMap[AppConstants.ServerKey.EMAIL] as? String ?? ""
                                    user.type = userMap[AppConstants.ServerKey.TYPE] as? String ?? ""
                                    user.username = userMap[AppConstants.ServerKey.USERNAME] as? String ?? ""
                                    VideonManager.shared().setMyData(user: user)
                                    
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                                
                                
                            }
                        } else {
                            self.showToast(message: response.message)
                        }
                        
                        
                    } else {
                        self.showToast(message: "Opps! Something went wrong, please try again.")
                    }
                    
                }
            }
        }
    }
}

