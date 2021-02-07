//
//  CongratulationVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//
import UIKit

class CongratulationVC: UIViewController {
    var countdownTimer: Timer!
    var totalTime = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.startTimer()
    }
    
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
