//
//  String+RemoveSpecialChars.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 8.10.2021.
//

import Foundation

extension String{
    func removeSpecChars() -> String{
       return self.replacingOccurrences(of: "<p>", with: "").replacingOccurrences(of: "<br />", with: "").replacingOccurrences(of: "</p>", with: "")
    }
}
