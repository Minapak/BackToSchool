//
//  Connectivity.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
