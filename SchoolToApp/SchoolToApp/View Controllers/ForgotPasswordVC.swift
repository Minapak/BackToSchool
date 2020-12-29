//
//  ForgotPasswordVC.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBAction func resetPasswordButtonAction(_ sender: Any) {
        
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
