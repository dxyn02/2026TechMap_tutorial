//
//  CookieModel.swift
//  CookieDungeon
//
//  Created by 앤디 on 8/17/26.
//

import Foundation

enum CookieModel: String, CaseIterable {
    case creamSoda = "Cream_Soda_Cookie_Epic_Skin"
    
    var filename: String {
        return self.rawValue
    }
}
