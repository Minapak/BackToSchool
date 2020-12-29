//
//  SignInVC.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit
import SwiftValidator
import SimpleCheckbox
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import LGButton
import ZKProgressHUD


class SignInVC: UIViewController, ValidationDelegate {
    let validator = Validator()
    @IBOutlet weak var loginWithFbButton: LGButton!
    @IBOutlet weak var loginWithGoogleButton: LGButton!
    @IBOutlet weak var signInButton: LGButton!
    @IBOutlet weak var signInTitleLabel: UILabel!
    @IBOutlet weak var orSeparatorLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var rememberLabel: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var dontHaveAccountLabel: UILabel!
    @IBOutlet weak var signUpTextButton: UIButton!
    
    
    @IBOutlet weak var checkBox: Checkbox!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    func logInWithFacebook(){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error in
            if error != nil {
                print("Failed to login: \(error?.localizedDescription)")
            } else if result?.isCancelled != nil {
                print("The token is \(result?.token?.tokenString ?? "")")
                if result?.token?.tokenString != nil {
                    print("Logged in")
                    guard let accessToken = AccessToken.current else {
                        print("Failed to get access token")
                        return
                    }
                    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    ZKProgressHUD.show("Please wait...")
                    // Perform login by calling Firebase APIs
                    Auth.auth().signIn(with: credential) { (user, error) in
                        if let error = error {
                            print("Login error: \(error.localizedDescription)")
                            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okayAction)
                            self.present(alertController, animated: true, completion: nil)
                            return
                        } else {
                            print("FB user:")
                            print(user?.description)
                            
                            let user = Auth.auth().currentUser
                            let displayName = user?.displayName ?? ""
                            let email = user?.email ?? ""
                            let uid = user?.uid ?? ""
                            self.doSignUp(registrationType: 3, socialId: uid, userName: displayName, email: email, password: "")
                        }
                        
                        
                    }
                    
                } else {
                    print("Cancelled")
                }
            }
        })
    }
    
    @IBAction func loginWithFacebookBtnAction(_ sender: Any) {
        self.logInWithFacebook()
        
    }
    
    @IBAction func loginWithGoogleBtnAction(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func forgetPasswordBtnAction(_ sender: Any) {
        var emailAddress = ""
        
        let alertController = UIAlertController(title: "Forget Password", message: "Please enter your email address and we'll send you an email to reset your password", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter your email address"
            
        }
        
        let resetAction = UIAlertAction(title: "Reset Password", style: .default, handler: { alert -> Void in
            
            
            
            emailAddress = (alertController.textFields?.first as! UITextField).text ?? ""
            print(emailAddress)
            
            if(emailAddress == ""){
                self.showAlertDialog(title: "Error!", message: "No valid email address found")
            } else {
                
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PasswordRecoveryVC") as! PasswordRecoveryVC
                vc.email = emailAddress
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil )
        
        
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func signInBtnAction(_ sender: Any) {
        print("Validating...")
        validator.validate(self)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initValidatorStyleTransformers()
        registerTextField()
        initCheckBoxUI()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
    }
    
    func changeLanguage()
    {
        let languageCode = AppUtils.getAppLanguage()
        print("Selected App Language Code: \(languageCode)")
        
        
        self.loginWithFbButton.titleString = "loginWithFBKey".localizableString(loc: languageCode)
        self.loginWithGoogleButton.titleString = "loginWithGoogleKey".localizableString(loc: languageCode)
        self.forgotPasswordButton.setTitle("forgotPasswordKey".localizableString(loc: languageCode), for: .normal)
        self.signInButton.titleString = "SignInKey".localizableString(loc: languageCode)
        self.signUpTextButton.setTitle("signUpKey".localizableString(loc: languageCode), for: .normal)
        
        self.signInTitleLabel.text = "SignInKey".localizableString(loc: languageCode)
        self.orSeparatorLabel.text = "orKey".localizableString(loc: languageCode)
        self.emailLabel.text = "emailKey".localizableString(loc: languageCode)
        self.passwordLabel.text = "passwordKey".localizableString(loc: languageCode)
        self.rememberLabel.text = "rememberPasswordKey".localizableString(loc: languageCode)
        self.dontHaveAccountLabel.text = "dontHaveAccountKey".localizableString(loc: languageCode)
        
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
        validator.registerField(emailTextField, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule(message: "Invalid email address")])
        validator.registerField(passwordTextField, errorLabel: passwordErrorLabel, rules: [RequiredRule(), MinLengthRule(length: 2)])
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
    
    // ValidationDelegate methods
    
    func validationSuccessful() {
        
        // Submit the form to videon api
        self.doSignIn(email: self.emailTextField.text!, password: self.passwordTextField.text!)
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        
    }
    
    func doSignIn(email:String, password:String){
        ZKProgressHUD.show("Please wait...")
        DispatchQueue.global().async {
            VideonManager.shared().logIn(emailValue: email, passwordValue: password){ (response, message) in
                DispatchQueue.main.async {
                    ZKProgressHUD.dismiss()
                    if response != nil {
                        print("doSignIn: Received Responce: \(response)")
                        self.showToast(message: response.message)
                        
                        if(response.status == 200){
                            // Parsing the data:
                            if let userMap = response.data as? [String : Any] {
                                var user = UserModel.init()
                                user.id = userMap[AppConstants.ServerKey.ID] as? String ?? ""
                                user.email = userMap[AppConstants.ServerKey.EMAIL] as? String ?? ""
                                user.type = userMap[AppConstants.ServerKey.TYPE] as? String ?? ""
                                user.username = userMap[AppConstants.ServerKey.USERNAME] as? String ?? ""
                                VideonManager.shared().setMyData(user: user)
                                self.navigationController?.popToRootViewController(animated: true)
                                
                            }
                        } else {
                            self.showToast(message: response.message)
                        }
                    } else {
                        self.showToast(message: "Opps! Signed in failed")
                    }
                    
                }
            }
        }
    }
    
    func firebaseResetPasswordForEmail(email: String){
        print("RESET PASS EMAIL: \(email)")
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .userNotFound:
                    // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    self.showAlertDialog(title: "Error!", message: "The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.")
                case .invalidEmail:
                    // Error: The email address is badly formatted.
                    self.showAlertDialog(title: "Error!", message: "The email address is badly formatted.")
                case .invalidRecipientEmail:
                    // Error: Indicates an invalid recipient email was sent in the request.
                    self.showAlertDialog(title: "Error!", message: "Indicates an invalid recipient email was sent in the request.")
                case .invalidSender:
                    // Error: Indicates an invalid sender email is set in the console for this action.
                    self.showAlertDialog(title: "Error!", message: "Indicates an invalid sender email is set in the console for this action.")
                case .invalidMessagePayload:
                    // Error: Indicates an invalid email template for sending update email.
                    self.showAlertDialog(title: "Error!", message: "Indicates an invalid email template for sending update email.")
                default:
                    print("Error message: \(error.localizedDescription)")
                }
            } else {
                //printLog("Reset password email has been successfully sent")
                self.showToast(message: "Reset password email has been successfully sent")
            }
        }
    }
    
    func firebaseSignInUsingEmailPassword(email:String, password:String){
        //let email = "example@gmail.com"
        //let password = "fooPassword"
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error as? NSError {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    self.showAlertDialog(title: "Error!", message: "Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase")
                case .userDisabled:
                    // Error: The user account has been disabled by an administrator.
                    self.showAlertDialog(title: "Error!", message: "The user account has been disabled by an administrator.")
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    self.showAlertDialog(title: "Error!", message: "The password is invalid or the user does not have a password.")
                case .invalidEmail:
                    // Error: Indicates the email address is malformed.
                    self.showAlertDialog(title: "Error!", message: "Indicates the email address is malformed.")
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                print("User signs in successfully")
                //let userInfo = Auth.auth().currentUser
                //let email = userInfo?.email
                
                self.showToast(message: "User signs in successfully")
                //self.dismiss(animated: true, completion: nil)
                // self.navigationController?.popToRootViewController(animated: true)
                
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
                                    print("< # > \(user)")
                                    
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

extension SignInVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //Sign in functionality will be handled here
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        ZKProgressHUD.show("Please wait...")
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Login Successful.")
                //This is where you should add the functionality of successful login
                //i.e. dismissing this view or push the home view controller etc
                let user = Auth.auth().currentUser
                let displayName = user?.displayName ?? ""
                let email = user?.email ?? ""
                let uid = user?.uid ?? ""
                self.doSignUp(registrationType: 2, socialId: uid, userName: displayName, email: email, password: "")
                
                
            }
            
        }
        
    }
}
