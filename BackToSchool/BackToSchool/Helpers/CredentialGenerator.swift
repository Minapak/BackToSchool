//
//  CredentialGenerator.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import Foundation

/// This class retrieves the credentials from the local file and pass it to the application for use in build time.
class CredentialGenerator {
    
    /// Retrieve the Google credentials and return those
    ///
    /// - Returns: Google data
    static func getGoogleCredentials() -> (id: String, schema: String, pKey: String) {
        let credentialDic = readCredentialJson()
        let id = credentialDic["googleClientID"] as? String
        let schema = credentialDic["googleSchema"] as? String
        let pKey = credentialDic["googlePlaceKey"] as? String
        return (id!, schema!, pKey!)
    }
    
    /// Retrieve the Facebook credentials and return those
    ///
    /// - Returns: Facebook data
    static func getFacebookCredentials() -> (String) {
        let credentialDic = readCredentialJson()
        let id = credentialDic["faceBookAppId"] as? String
        return (id!)
    }
    
    static func getBaseCredentials() -> (baseUrl: String,  thumbUrl: String, fileUrl: String) {
        let credentialDic = readCredentialJson()
        
        //"baseUrl": "http://3.138.134.200/BackToSchool/public/",
        //"fileUrl": "http://3.138.134.200/BackToSchool/public/uploads/",
        //"thumbUrl": "http://3.138.134.200/BackToSchool/public/uploads/thumb/",
        
//        let baseUrl = credentialDic["baseUrl"] as? String ?? ""
//        let fileUrl = credentialDic["fileUrl"] as? String ?? ""
//        let thumbUrl = credentialDic["thumbUrl"] as? String ?? ""
        
        let baseUrl = "http://3.138.134.200/BackToSchool/public/"
        let fileUrl = "http://3.138.134.200/BackToSchool/public/uploads/"
        let thumbUrl = "http://3.138.134.200/BackToSchool/public/uploads/thumb/"
        
        print("getBaseCredentials: >> \(baseUrl)")
        print("getBaseCredentials: >> \(fileUrl)" )
        print("getBaseCredentials: >> \(thumbUrl)")
        
        
        return (baseUrl, fileUrl, thumbUrl)
    }
    
    /// Check a local file(json) for credentials, if found return a dictionary.
    ///
    /// - Returns: Dictionary of credentials
    private static func readCredentialJson() -> Dictionary<String, Any> {
        if let path = Bundle.main.path(forResource: "AppCredentials", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let dictionary = jsonResult as? [String: AnyObject] {
                    print(dictionary)
                    return dictionary
                }
            } catch {
                print("readCredentialJson \(error)")
            }
        }
        return [String: AnyObject]()
    }
}
