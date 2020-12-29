//
//  AppUtils.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import UIKit
import Foundation
//import SkyFloatingLabelTextField

class AppUtils {
    
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    static var loadingViewParent:UIView? = nil
    
    /// This method help for debug log print.
    ///
    /// - Parameters:
    ///   - tag: description String
    ///   - printObject: object for print
    static func log(tag: String?, printObject: Any?) {
        var tagStr:String? = tag
        if (tagStr ?? "").isEmpty {
            tagStr = "StreamZ"
        }
        print("\(tagStr!): \(printObject ?? "nil")")
    }
    
    
    /// Set language for app
    /// - Parameter languageCode: Language code in english
    static func setAppLanguage(languageCode:String)
    {
        let defaults = UserDefaults.standard
        //Set
        defaults.set(languageCode, forKey: "appLanguage")
    }
    
    /// Get application language
    static func getAppLanguage() -> String
    {
        let defaults = UserDefaults.standard
        //Get
        guard let appLanguageCode = defaults.string(forKey: "appLanguage") else { return "en" }
        return appLanguageCode
    }
    
    /// Change app language
    func changeLanguage()
    {
        let languageCode = AppUtils.getAppLanguage()
        
        
        if(languageCode == "en"){
            // Text lebels for this viewController
            
        } else if (languageCode == "zh-Hans"){
            // Text lebels for this viewController
            
        }
    }
}
