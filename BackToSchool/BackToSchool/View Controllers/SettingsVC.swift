//
//  SettingsVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//


import UIKit
import Firebase

class SettingsVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var aboutUsButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var signInSignOutButton: UIButton!
    
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func aboutUsButtonAction(_ sender: Any) {
        // WebVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        vc.pageTitle = "About Us"
        vc.htmlFileName = "about-us"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func privacyPolicyButtonAction(_ sender: Any) {
        // WebVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebVC") as! WebVC
        vc.pageTitle = "Privacy & policy"
        vc.htmlFileName = "privacy-policy"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func signOutButtonAction(_ sender: Any) {
        
        let appLanguageCode = AppUtils.getAppLanguage()
        if(signInSignOutButton.titleLabel?.text == "SignInKey".localizableString(loc: appLanguageCode))
        {
            signInSignOutButton.setTitle("SignOutKey".localizableString(loc: appLanguageCode), for: .normal)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else {
            // Manual sign out
            VideonManager.shared().removeMyData()
            
            // Call for sign out
            do {
                try Auth.auth().signOut()
                self.showToast(message: "Sign out successful")
                signInSignOutButton.setTitle("SignInKey".localizableString(loc: appLanguageCode), for: .normal)
            } catch {
                print("Sign out error")
                self.showToast(message: "Sign out error")
            }
        }
        
    }
    @IBAction func changeLanguageButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Select Language", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ENGLISH", style: .default , handler:{ (UIAlertAction)in
            
            self.showToast(message: "ENGLISH selected")
            self.languageButton.setTitle("English", for: .normal)
            AppUtils.setAppLanguage(languageCode: "en")
            self.changeLanguage()
            
        }))
        
        alert.addAction(UIAlertAction(title: "CHINESE", style: .default , handler:{ (UIAlertAction)in
            
            self.showToast(message: "CHINESE selected")
            self.languageButton.setTitle("Chinese", for: .normal)
            AppUtils.setAppLanguage(languageCode: "zh-Hans")
            self.changeLanguage()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler:{ (UIAlertAction)in
            print("User click Dismiss button")
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    @IBOutlet weak var changeLanguageButton: UIButton!
    
    @IBAction func copyToClipBoardButtonAction(_ sender: Any) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = textField.text
        
        showToast(message: "Text copied to clipboard")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeLanguage()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isUserLoggedIn() {
            
            
            if(AppUtils.getAppLanguage() == "en")
            {
                signInSignOutButton.setTitle("SignOutKey".localizableString(loc: "en"), for: .normal)
                
            } else if (AppUtils.getAppLanguage() == "zh-Hans") {
                signInSignOutButton.setTitle("SignOutKey".localizableString(loc: "zh-Hans"), for: .normal)
            }
        } else {
            
            signInSignOutButton.setTitle("Sign In", for: .normal)
            if(AppUtils.getAppLanguage() == "en")
            {
                
                signInSignOutButton.setTitle("SignInKey".localizableString(loc: "en"), for: .normal)
                
            } else if (AppUtils.getAppLanguage() == "zh-Hans"){
                signInSignOutButton.setTitle("SignInKey".localizableString(loc: "zh-Hans"), for: .normal)
            }
        }
    }
    
    func isUserLoggedIn() -> Bool {
        var user = UserModel.init()
        user = VideonManager.shared().getMyData()
        
        return user.id != ""
    }
    
    func changeLanguage()
    {
        let languageCode = AppUtils.getAppLanguage()
        print("Selected App Language Code: \(languageCode)")
        
        if(languageCode == "en"){
            // Text lebels for this viewController
            self.languageButton.setTitle("English", for: .normal)
            self.titleLabel.text = "SettingsKey".localizableString(loc: "en")
            self.aboutUsButton.setTitle("AboutUsKey".localizableString(loc: "en"), for: .normal)
            self.privacyPolicyButton.setTitle("PrivacyPolicyKey".localizableString(loc: "en"), for: .normal)
            if isUserLoggedIn() {
                signInSignOutButton.setTitle("SignOutKey".localizableString(loc: "en"), for: .normal)
            }
            else {
                signInSignOutButton.setTitle("SignInKey".localizableString(loc: "en"), for: .normal)
            }
            
        } else if (languageCode == "zh-Hans"){
            // Text lebels for this viewController
            self.languageButton.setTitle("Chinese", for: .normal)
            self.titleLabel.text = "SettingsKey".localizableString(loc: "zh-Hans")
            self.aboutUsButton.setTitle("AboutUsKey".localizableString(loc: "zh-Hans"), for: .normal)
            self.privacyPolicyButton.setTitle("PrivacyPolicyKey".localizableString(loc: "zh-Hans"), for: .normal)
            if isUserLoggedIn() {
                signInSignOutButton.setTitle("SignOutKey".localizableString(loc: "zh-Hans"), for: .normal)
            }
            else {
                signInSignOutButton.setTitle("SignInKey".localizableString(loc: "zh-Hans"), for: .normal)
            }
            
        }
    }
    
}
