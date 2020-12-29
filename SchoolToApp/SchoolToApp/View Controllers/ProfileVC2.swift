//
//  ProfileVC2.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import UIKit
import LZViewPager
import Firebase
import SDWebImage


class ProfileVC2: UIViewController {
    
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBAction func backButtonAction(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var viewPager: LZViewPager!
    private var subControllers:[UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            // do some tasks..
            profileImageView.layer.cornerRadius = profileImageView.frame.width/2
            profileImageView.layer.borderWidth = 1
            profileImageView.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            viewPager.dataSource = self
            viewPager.delegate = self
            viewPager.hostController = self
            
            let appLanguageCode = AppUtils.getAppLanguage()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc1 = storyboard.instantiateViewController(withIdentifier: "FavouriteVC") as! FavouriteVC
            vc1.title = "FavouriteKey".localizableString(loc: appLanguageCode)
            let vc2 = storyboard.instantiateViewController(withIdentifier: "PlaylistVC") as! PlaylistVC
            vc2.title =  "PlaylistKey".localizableString(loc: appLanguageCode)
            subControllers = [vc1, vc2]
            viewPager.reload()
            
            if isUserLoggedIn() {
                
                let user = VideonManager.shared().getMyData()
                if(user.type == "1"){
                    // Show logout page
                    nameLabel.text = user.username
                    emailLabel.text = user.email
                    profileImageView.image = UIImage.init(named: "default_category_img")
                    
                } else {
                    // Show logout page
                    let userInfo = Auth.auth().currentUser
                    nameLabel.text = userInfo?.displayName ?? ""
                    emailLabel.text = userInfo?.email ?? ""
                    
                    profileImageView.sd_setImage(with: userInfo?.photoURL, placeholderImage:UIImage.init(named: "default_category_img"), completed: nil)
                }
                
                
            } else {
                // Show login page
                nameLabel.text = ""
                emailLabel.text = ""
            }
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoInternetVC") as! NoInternetVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    /// Check login status
    func isUserLoggedIn() -> Bool {
        var user = UserModel.init()
        user = VideonManager.shared().getMyData()
        
        return user.id != ""
    }
    
    
    
    
    
}

extension ProfileVC2: LZViewPagerDelegate, LZViewPagerDataSource {
    func numberOfItems() -> Int {
        return self.subControllers.count
    }
    
    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }
    
    
    func button(at index: Int) -> UIButton {
        //Customize your button styles here
        let button = UIButton()
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.orange, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }
    
    func heightForHeader() -> CGFloat {
        return 45
    }
    func colorForIndicator(at index: Int) -> UIColor {
        return UIColor.orange
    }
    func shouldEnableSwipeable() -> Bool {
        return true
    }
}
