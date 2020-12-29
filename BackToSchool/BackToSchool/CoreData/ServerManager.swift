//
//  ServerManager.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//


import Foundation
import Alamofire

class ServerManager {
    
    // Common method for HTTP request
    static func requestForPostData(url: String, param: [String : Any], complitionHandler: @escaping(_ response: ResponseModel?) -> Void) {
        AppUtils.log(tag: "requestForGetData url ", printObject: url)
        AppUtils.log(tag: "requestForGetData param ", printObject: param)
    
        if !url.isEmpty  {
            Alamofire.request(url, method: .post, parameters: param).responseJSON { (response) in
                var appResponse = ResponseModel.init()
                switch response.result {
                case .success :
                    AppUtils.log(tag: "response.result ", printObject: response.result)
                    if let jsonObj = response.result.value as? [String: Any] {
                        AppUtils.log(tag: "jsonObj ", printObject: jsonObj)
                        appResponse.status = jsonObj[AppConstants.ServerKey.STATUS_CODE] as? Int ?? 0
                        appResponse.message = jsonObj[AppConstants.ServerKey.MESSAGE] as? String ?? ""
                        appResponse.data = jsonObj[AppConstants.ServerKey.DATA]
                        complitionHandler(appResponse)
                    } else {
                        appResponse.message = "Json format mismatch"
                        complitionHandler(appResponse)
                    }
                case .failure :
                    AppUtils.log(tag: "requestForGetData error", printObject: response.result.error)
                    appResponse.message = response.result.error.debugDescription
                    complitionHandler(appResponse)
                }
            }
        }
    }
}

