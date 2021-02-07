//
//  WelcomeVC.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/30.
//

import UIKit
import SlideMenuControllerSwift

class WelcomeVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var img_random: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    //방송보기
    @IBOutlet weak var btnTV: UIButton!
    //MARK: Variables
    var imageTimer = Timer()
    
    //MARK: Viewcontroller lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnLogin.layer.cornerRadius = 8.0
        self.btnTV.layer.cornerRadius = 8.0
        self.btnTV.layer.masksToBounds = true
        self.btnSkip.layer.cornerRadius = 8.0
        self.btnSkip.layer.borderColor = UIColor.white.cgColor
        self.btnSkip.layer.borderWidth = 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.changeImage()
        self.imageTimer.invalidate()
        self.imageTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        self.imageTimer.invalidate()
    }
    
}

//MARK: Functions
extension WelcomeVC {
    @objc func changeImage() {
        let images: [UIImage] = [UIImage(named: "bts3_background")!,UIImage(named: "bts3_background")!,UIImage(named: "bts3_background")!,UIImage(named: "bts3_background")!,UIImage(named: "bts3_background")!]
        self.img_random.image = images.shuffled().randomElement()
    }
}

//MARK: Actions
extension WelcomeVC {
    @IBAction func btnLogin_Clicked(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func btnTV_Clicked(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func btnRegister_Clicked(_ sender: UIButton) {
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(objVC, animated: true)
    }
    
    @IBAction func btnSkip_Clicked(_ sender: UIButton) {
        UserDefaults.standard.set("0", forKey: UD_userId)
        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let sidemenuVC = self.storyboard?.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
        let appNavigation: UINavigationController = UINavigationController(rootViewController: objVC)
        appNavigation.setNavigationBarHidden(true, animated: true)
        let slideMenuController = SlideMenuController(mainViewController: appNavigation, leftMenuViewController: sidemenuVC)
        slideMenuController.changeLeftViewWidth(UIScreen.main.bounds.width * 0.8)
        slideMenuController.removeLeftGestures()
        UIApplication.shared.windows[0].rootViewController = slideMenuController
    }
}
