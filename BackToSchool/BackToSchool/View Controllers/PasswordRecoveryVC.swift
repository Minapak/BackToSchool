//
//  PasswordRecoveryVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//


import UIKit
import LGButton

class PasswordRecoveryVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var enterCodeTextField: UITextField!
    @IBOutlet weak var codeCounterLabel: UILabel!
    @IBOutlet weak var proceedButton: LGButton!
    @IBOutlet weak var resendCodeButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
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
    var totalTime = 180
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
        self.proceedButton.isEnabled = true
        self.resendCodeButton.isEnabled = false
        self.timerLabel.isHidden = false
        
    }
    
    @objc func updateTime() {
        if(totalTime > 0)
        {
            timerLabel.text = "\(totalTime)"
        }
        
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        self.proceedButton.isEnabled = false
        self.resendCodeButton.isEnabled = true
        self.timerLabel.isHidden = true
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
                            self.showToast(message: "회원님의 이메일로 인증번호 4자리를 보냈습니다!")
                            
                        }
                        else {
                            self.showToast(message: response.message)
                        }
                        
                    } else {
                        self.showToast(message: "잘 못 보냈습니다!")
                        
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
                                
                                let verificationTokenFromServer = userMap["verification_token"] as? String ?? ""
                                
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                                vc.email = email
                                vc.verificationTokenFromServer = verificationTokenFromServer
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
        
        return newString.length <= maxLength
    }
    
    
}

