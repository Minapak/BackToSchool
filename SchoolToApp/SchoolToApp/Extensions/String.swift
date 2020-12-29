//
//  String.swift
//  SchoolToApp
//
//  Created by 박은민 on 2020/12/29.
//

import Foundation

extension String{
    func localizableString(loc: String) -> String{
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")
        let bundle = Bundle(path: path!)
         
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
