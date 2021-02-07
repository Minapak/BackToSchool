//
//  SignInVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
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
import SwiftyJSON
import SlideMenuControllerSwift
import AuthenticationServices
import CryptoKit

class SignInVC: UIViewController, ValidationDelegate{
//                , ASAuthorizationControllerPresentationContextProviding {
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return view.window!
//    }
    
    let validator = Validator()

    
    
    static var pass: String?
    
    // Storyboard
//    @IBOutlet weak var appleSignInButton: UIStackView!
//    @IBOutlet weak var loginWithFbButton: LGButton!
//    @IBOutlet weak var loginWithGoogleButton: LGButton!
    
    
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
    
//    func logInWithFacebook(){
//        let loginManager = LoginManager()
//        loginManager.logIn(permissions: ["public_profile", "email"], from: self, handler: { result, error in
//            if error != nil {
//                print("Failed to login: \(error?.localizedDescription)")
//            } else if result?.isCancelled != nil {
//                print("The token is \(result?.token?.tokenString ?? "")")
//                if result?.token?.tokenString != nil {
//                    print("Logged in")
//                    guard let accessToken = AccessToken.current else {
//                        print("Failed to get access token")
//                        return
//                    }
//                    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
//                    ZKProgressHUD.show("Please wait...")
//                    // Perform login by calling Firebase APIs
//                        Auth.auth().signIn(with: credential) { (user, error) in
//                        if let error = error {
//                            print("Login error: \(error.localizedDescription)")
//                            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
//                            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                            alertController.addAction(okayAction)
//                            self.present(alertController, animated: true, completion: nil)
//                            return
//                        } else {
//                            print("FB user:")
//                            print(user?.description)
//
//                            let user = Auth.auth().currentUser
//                            let displayName = user?.displayName ?? ""
//                            let email = user?.email ?? ""
//                            let uid = user?.uid ?? ""
//                            self.doSignUp(registrationType: 3, socialId: uid, userName: displayName, email: email, password: "")
//
//                            let urlString = API_URL + "login.php"
//                            let params: NSDictionary = ["email":email,
//                                                        "password":"",
//                                                        "device_type":"2",
//                                                        "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
//                            self.Webservice_Login(url: urlString, params: params)
//
//                        }
//
//
//                    }
//
//                } else {
//                    print("Cancelled")
//                }
//            }
//        })
//    }
//
//    private func randomNonceString(length: Int = 32) -> String {
//      precondition(length > 0)
//      let charset: Array<Character> =
//          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//      var result = ""
//      var remainingLength = length
//
//      while remainingLength > 0 {
//        let randoms: [UInt8] = (0 ..< 16).map { _ in
//          var random: UInt8 = 0
//          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
//          if errorCode != errSecSuccess {
//            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
//          }
//          return random
//        }
//
//        randoms.forEach { random in
//          if remainingLength == 0 {
//            return
//          }
//
//          if random < charset.count {
//            result.append(charset[Int(random)])
//            remainingLength -= 1
//          }
//        }
//      }
//
//        return result
//
//    }
//    // Unhashed nonce.
//       public var currentNonce: String?
//    public var currentNonce1: String?
//
//
//    @objc
//     func handleAppleIDAuthorization() {
////         let request = ASAuthorizationAppleIDProvider().createRequest()
////         request.requestedScopes = [.fullName, .email]
//
//
//        let nonce = randomNonceString()
//               currentNonce = nonce
//               let appleIDProvider = ASAuthorizationAppleIDProvider()
//               let request = appleIDProvider.createRequest()
//               request.requestedScopes = [.fullName, .email]
//
//
//
//
//               request.nonce = sha256(nonce)
//
//
//
//         let controller = ASAuthorizationController(authorizationRequests: [request])
//
//         controller.delegate = self
//         controller.presentationContextProvider = self
//
//         controller.performRequests()
//     }
//    private func sha256(_ input: String) -> String {
//          let inputData = Data(input.utf8)
//          let hashedData = SHA256.hash(data: inputData)
//          let hashString = hashedData.compactMap {
//              return String(format: "%02x", $0)
//          }.joined()
//
//          return hashString
//      }
//
//
//     func loginWithApple() {
//        if #available(iOS 13.0, *) {
//
//            let button = ASAuthorizationAppleIDButton()
//                   button.addTarget(self, action: #selector(handleAppleIDAuthorization), for: .touchUpInside)
//
//                    self.appleSignInButton.addArrangedSubview(button)
//           } else {
//               self.showToast(message: "애플 로그인은 iOS13 이상부터 사용이 가능합니다.")
//
//           }
//
//    }
//
//    @IBAction func loginWithFacebookBtnAction(_ sender: Any) {
//        self.logInWithFacebook()
//
//    }
//
//    @IBAction func loginWithGoogleBtnAction(_ sender: Any) {
//        GIDSignIn.sharedInstance().signIn()
//    }
    
    @IBAction func forgetPasswordBtnAction(_ sender: Any) {
        var emailAddress = ""
        
        let alertController = UIAlertController(title: "비밀번호 찾기", message: "회원님의 이메일을 적어주시면 회원님의 이메일로 새로운 비밀번호를 보내드립니다.", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "회원님의 이메일을 적어주세요."
            
        }
        
        let resetAction = UIAlertAction(title: "비밀번호 초기화", style: .default, handler: { alert -> Void in
            
            
            
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
        
        let cancelAction = UIAlertAction(title: "취소", style: .destructive, handler: nil )
        
        
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func signInBtnAction(_ sender: Any) {
        print("검증중...")
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
        
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance().delegate = self
//        loginWithApple()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
    }
    
    func changeLanguage()
    {
        let languageCode = AppUtils.getAppLanguage()
        print("Selected App Language Code: \(languageCode)")
        

//        self.loginWithFbButton.titleString = "loginWithFBKey".localizableString(loc: languageCode)
//        self.loginWithGoogleButton.titleString = "loginWithGoogleKey".localizableString(loc: languageCode)
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
        validator.registerField(emailTextField, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule(message: "존재하지 않는 이메일 주소 입니다.")])
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
        ZKProgressHUD.show("기다리세요...")
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
                                let urlString = API_URL + "login.php"
                                let params: NSDictionary = ["email":user.email,
                                                            "password":password,
                                                            "device_type":"2",
                                                            "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
                                self.Webservice_Login(url: urlString, params: params)
                                
                                VideonManager.shared().setMyData(user: user)
                                self.navigationController?.popToRootViewController(animated: true)
                                
                            }
                        } else {
                            self.showToast(message: response.message)
                        }
                    } else {
                        self.showToast(message: "로그인 실패")
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
                    self.showAlertDialog(title: "Error!", message: "파이어베이스 인증 섹션 에러.")
                case .invalidEmail:
                    // Error: The email address is badly formatted.
                    self.showAlertDialog(title: "Error!", message: "이메일 주소의 형식이 잘못되었습니다.")
                case .invalidRecipientEmail:
                    // Error: Indicates an invalid recipient email was sent in the request.
                    self.showAlertDialog(title: "Error!", message: "잘못된 수신자 이메일이 전송되었습니다.")
                case .invalidSender:
                    // Error: Indicates an invalid sender email is set in the console for this action.
                    self.showAlertDialog(title: "Error!", message: "잘못된 발신자 이메일이 콘솔에 설정되었습니다.")
                case .invalidMessagePayload:
                    // Error: Indicates an invalid email template for sending update email.
                    self.showAlertDialog(title: "Error!", message: "유효하지 않은 이메일 에러.")
                default:
                    print("Error message: \(error.localizedDescription)")
                }
            } else {
                //printLog("Reset password email has been successfully sent")
                self.showToast(message: "초기화 된 비밀번호를 이메일로 성공적으로 보냈습니다.")
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
                    self.showAlertDialog(title: "Error!", message: "이메일 및 비밀번호 계정이 활성화 되지 않았습니다.")
                case .userDisabled:
                    // Error: The user account has been disabled by an administrator.
                    self.showAlertDialog(title: "Error!", message: "관리자가 사용자 계정을 비활성화 했습니다.")
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    self.showAlertDialog(title: "Error!", message: "암호가 유효하지 않거나 유저에게 암호가 없습니다.")
                case .invalidEmail:
                    // Error: Indicates the email address is malformed.
                    self.showAlertDialog(title: "Error!", message: "이메일 주소가 잘못되었습니다.")
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                print("로그인 성공")
                //let userInfo = Auth.auth().currentUser
                //let email = userInfo?.email
                
                self.showToast(message: "로그인 성공")
                //self.dismiss(animated: true, completion: nil)
                // self.navigationController?.popToRootViewController(animated: true)
                
            }
        }
        
    }
    
    func doSignUp(registrationType: Int, socialId:String, userName: String, email:String, password:String){
        ZKProgressHUD.show("검증중...")
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
                                    //classpaper 로그인
                                    let urlString = API_URL + "login.php"
                                    let params: NSDictionary = ["email":user.email,
                                                                "password":password,
                                                                "device_type":"2",
                                                                "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
                                    self.Webservice_Login(url: urlString, params: params)
                                    
                                    
                                    
                                    
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


//extension SignInVC: ASAuthorizationControllerDelegate {
//    @available(iOS 13.0, *)
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//    
//        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//                   guard let nonce = currentNonce else {
//                       fatalError("Invalid state: A login callback was received, but no login request was sent.")
//                   }
//                   guard let appleIDToken = appleIDCredential.identityToken else {
//                       print("Unable to fetch identity token")
//                       return
//                   }
//                   guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//                       print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//                       return
//                   }
//                   let credential = OAuthProvider.credential(withProviderID: "apple.com",
//                                                             idToken: idTokenString,
//                                                             rawNonce: nonce)
//            Auth.auth().signIn(with: credential) { (authResult, error) in
//                       if (error != nil) {
//                           // Error. If error.code == .MissingOrInvalidNonce, make sure
//                           // you're sending the SHA256-hashed nonce as a hex string with
//                           // your request to Apple.
//                           print(error?.localizedDescription ?? "")
//                           return
//                       }
//                
//                let fullName = appleIDCredential.fullName
//                let givenName = fullName?.givenName
//                let familyName = fullName?.familyName
//                let displayName = "\(givenName) \(familyName)"
//                    updateDisplayName(displayName: displayName) // (1)
//                    
//                        
//
//        
//                       guard let user = authResult?.user else { return }
//                       var email = user.email ?? ""
//                      // var displayName = user.displayName ?? ""
//  
//                       guard let uid1 = Auth.auth().currentUser?.uid else { return }
//                       let uid = user.uid ?? ""
//                    
//           
//
//                            // Sign in using an existing iCloud Keychain credential.
//                    if  let passwordCredential = authorization.credential as? ASPasswordCredential {
//                    
//                    
//                        let username = passwordCredential.user
//                        let password = passwordCredential.password
//                    
//                    print("username: \(username)")
//                    print("password: \(password)")
//                        
//                        self.doSignUp(registrationType: 4, socialId: uid, userName: displayName, email: email, password: password)
//                        print(API_URL)
//                        
//                        let urlString1 = API_URL + "register.php"
//                        let params1: NSDictionary = ["username":displayName,
//                                                    "email":email,
//                                                    "password":password,
//                                                    "device_type":"2",
//                                                    "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
//                        self.Webservice_Register(url: urlString1, params: params1)
//                        let urlString = API_URL + "login.php"
//                        let params: NSDictionary = ["email":email,
//                                                    "password":password,
//                                                    "device_type":"2",
//                                                    "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
//                        self.Webservice_Login(url: urlString, params: params)
//                        print(urlString + "?????? urlString")
//                    }
//              
//                  
//                    
//                    self.doSignUp(registrationType: 4, socialId: uid, userName: displayName, email: email, password: nonce)
//                    print(API_URL)
//                
//                let urlString1 = API_URL + "register.php"
//                let params1: NSDictionary = ["username":displayName,
//                                            "email":email,
//                                            "password":nonce,
//                                            "device_type":"2",
//                                            "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
//                self.Webservice_Register(url: urlString1, params: params1)
//                    let urlString = API_URL + "login.php"
//                    let params: NSDictionary = ["email":email,
//                                                "password":nonce,
//                                                "device_type":"2",
//                                                "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
//                    self.Webservice_Login(url: urlString, params: params)
//                    print(urlString + "?????? urlString")
//                    
//                    //}
//                    
//                    
//          
//                    
//                   }
//               }
//           }
//           
//           func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//               // Handle error.
//               print("Sign in with Apple errored: \(error)")
//           }
//       }
//        
//public func updateDisplayName(displayName: String) { // (2)
//   if let user = Auth.auth().currentUser {
//     let changeRequest = user.createProfileChangeRequest() // (3)
//     changeRequest.displayName = displayName
//     changeRequest.commitChanges { error in // (4)
//       if error != nil {
//         print("Successfully updated display name for user [\(user.uid)] to [\(displayName)]")
//       }
//     }
//   }
// }
//
//extension SignInVC: GIDSignInDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        //Sign in functionality will be handled here
//        
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        guard let auth = user.authentication else { return }
//        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
//        ZKProgressHUD.show("기다리세요...")
//        Auth.auth().signIn(with: credentials) { (authResult, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("로그인 성공.")
//                
//                let user = Auth.auth().currentUser
//                let displayName = user?.displayName ?? ""
//                let email = user?.email ?? ""
//                let uid = user?.uid ?? ""
//                self.doSignUp(registrationType: 2, socialId: uid, userName: displayName, email: email, password: "")
//                
//                
//                
//                
//                let urlString = API_URL + "login.php"
//                let params: NSDictionary = ["email":email,
//                                            "password":"",
//                                            "device_type":"2",
//                                            "device_token":UserDefaultManager.getStringFromUserDefaults(key: UD_FcmToken)]
//                self.Webservice_Login(url: urlString, params: params)
//            }
//            
//        }
//        
//    }
//}

extension SignInVC
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

//MARK: Webservices
extension SignInVC
{
    func Webservice_Register(url:String, params:NSDictionary) -> Void {
        WebServices().CallGlobalAPI(url: url, headers: [:], parameters:params, httpMethod: "POST", progressView:true, uiView:self.view, networkAlert: true) {(_ jsonResponse:JSON? , _ strErrorMessage:String) in
            print(url, "url")
            print(params, "params")
            if strErrorMessage.count != 0 {
                showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: strErrorMessage)
            }
            else {
                print(jsonResponse!)
                let responseCode = jsonResponse!["ResponseCode"].stringValue
                print("responseCode : "+responseCode)
                if responseCode == "1" {
                    let responseData = jsonResponse!["ResponseData"].dictionaryValue
                    print(responseData , ": responseData")
                    let userId = responseData["id"]?.stringValue
                    print(userId , " : userId")
                    UserDefaultManager.setStringToUserDefaults(value: userId!, key: UD_userId)
                    //유저 이름 쉐어드프리퍼런스
               //     UserDefaultManager.setStringToUserDefaults(value: self.userNameTextField.text!, key: UD_userName)
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    
//                    let objVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
//                    let sideMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
//                    let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
//                    appNavigation.setNavigationBarHidden(true, animated: true)
//                    let slideMenuController = SlideMenuController(mainViewController: appNavigation, leftMenuViewController: sideMenuViewController)
//                    slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width * 0.8)
//                    slideMenuController.removeLeftGestures()
//                    UIApplication.shared.windows[0].rootViewController = slideMenuController
            }
                else {
                    showAlertMessage(titleStr: Bundle.main.displayName!, messageStr: jsonResponse!["ResponseMessage"].stringValue)
                }
            }
        }
    }
}


