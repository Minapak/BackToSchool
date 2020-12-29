//
//  Connectivity.swift
//  BackToSchool
//
//  Created by 박은민 on 2020/12/23.
//

import Foundation
import Alamofire
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
