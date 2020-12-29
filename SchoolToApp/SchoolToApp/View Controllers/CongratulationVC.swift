//
//  CongratulationVC.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit

class CongratulationVC: UIViewController {
    var countdownTimer: Timer!
    var totalTime = 2
    
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
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
