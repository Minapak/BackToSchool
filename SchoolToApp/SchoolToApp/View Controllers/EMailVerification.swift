//
//  EMailVerification.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit
import LGButton
class EMailVerificationVC: UIViewController, UITextFieldDelegate {
    
    // Outlets
    @IBOutlet weak var enterCodeTextField: UITextField!
    @IBOutlet weak var codeCounterLabel: UILabel!
    @IBOutlet weak var timerCounterLabel: UILabel!
    @IBOutlet weak var proceedButton: LGButton!
    @IBOutlet weak var resendButton: UIButton!
    
    @IBAction func proceedButtonAction(_ sender: Any) {
        self.verifyEmail(email: email, verificationToken: enterCodeTextField.text ?? "")
    }
    
    @IBAction func resendCodeButtonAction(_ sender: Any) {
        self.sendCode(email: email)
        self.startTimer()
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    var email = ""
    var countdownTimer: Timer!
    var totalTime = 60
    var verificationTokenFromServer = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sendCode(email: email)
        self.startTimer()
        self.enterCodeTextField.delegate = self
        self.enterCodeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let strLength = textField.text!.count
        if(strLength <= 4){self.codeCounterLabel.text = "\(strLength)/4"}
        if(strLength == 4){
            self.proceedButton.isEnabled = true
        } else {
            self.proceedButton.isEnabled = false
        }
    }
    func startTimer() {
        self.totalTime = 60
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        //self.proceedButton.isEnabled = true
        self.resendButton.isEnabled = false
        self.timerCounterLabel.isHidden = false
        
    }
    
    @objc func updateTime() {
        
        if(totalTime > 0)
        {
            timerCounterLabel.text = "\(totalTime)"
        }
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        //self.proceedButton.isEnabled = false
        self.resendButton.isEnabled = true
        self.timerCounterLabel.isHidden = true
    }
    
    // Send code to email request
    func sendCode(email: String)
    {
        DispatchQueue.global().async {
            VideonManager.shared().sendVerificationCode(emailValue: email){ (response, message) in
                
                DispatchQueue.main.async {
                    if response != nil {
                        if (response.status == 200)
                        {
                            self.showToast(message: "4 digit code sent to your email")
                            
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
    
    
    // Verify email address with verification code
    func verifyEmail(email:String, verificationToken: String){
        DispatchQueue.global().async {
            VideonManager.shared().verifyEmail(emailValue: email, verificationTokenValue: verificationToken){ (response, message) in
                
                DispatchQueue.main.async {
                    if response != nil {
                        if (response.status == 200)
                        {
                            // Parsing the data:
                            if let userMap = response.data as? [String : Any] {
                                
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        let strLength = textField.text?.count ?? 0
        if(strLength <= maxLength){self.codeCounterLabel.text = "\(strLength)/4"}
        
        
        return newString.length <= maxLength
    }
}
