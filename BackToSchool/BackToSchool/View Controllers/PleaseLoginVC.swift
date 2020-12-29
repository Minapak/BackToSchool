//
//  PleaseLoginVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import UIKit
import LGButton

class PleaseLoginVC: UIViewController {
    @IBOutlet weak var pleaseLoginLabel: UILabel!
    @IBOutlet weak var logInButton: LGButton!
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func pleaseLogInButtonAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.changeLanguage()
    }
    
    func changeLanguage()
    {
        let languageCode = AppUtils.getAppLanguage()
        print("Selected App Language Code: \(languageCode)")
        
        self.logInButton.titleString = "LoginKey".localizableString(loc: languageCode)
        self.pleaseLoginLabel.text = "PleaseLogInKey".localizableString(loc: languageCode)
        
    }
}
