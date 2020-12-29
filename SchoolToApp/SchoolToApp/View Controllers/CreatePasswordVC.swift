//
//  CreatePasswordVC.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit
import SwiftValidator

class CreatePasswordVC: UIViewController, ValidationDelegate {
    let validator = Validator()
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    @IBAction func sibmitButtonAction(_ sender: Any) {
        print("submit button pressed")
        print("Validating...")
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
    }
    
    func validationFailed(_ errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        
    }
    
    func updatePassword(email: String, verificationToken: String, password: String){
        DispatchQueue.global().async {
            VideonManager.shared().updatePassword(emailValue: email, verificationTokenValue: verificationToken, passwordValue: password){ (response, message) in
                
                DispatchQueue.main.async {
                    if response != nil {
                        if (response.status == 200)
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CongratulationVC") as! CongratulationVC
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

