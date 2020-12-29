//
//  UIImageView.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import UIKit
import Photos
import SDWebImage

extension UIImageView {
    
    /// Check profile image path and Show on view.
    /// - Parameters:
    ///   - path: String
    ///   - genderID: Int
    ///   - isThumb: Bool
    func showImage(path: String?) {
        if path == nil {return}
        self.sd_imageTransition = .fade
         self.sd_setImage(with: URL(string: path!), placeholderImage:UIImage.init(named: "default_img.png"), completed: nil)
    }
    
    func showCategoryImage(path: String?) {
        if path == nil {return}
        self.sd_imageTransition = .fade
         self.sd_setImage(with: URL(string: path!), placeholderImage:UIImage.init(named: "default_category_img.png"), completed: nil)
    }
    
}
