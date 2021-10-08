//
//  NetResponseModel.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 3.10.2021.
//

import Foundation

struct NetResponseModel<T : Codable> : Codable{
    
    var rawData : Data?
    
    var json : String?{
        guard let rawData = rawData else {return nil}
        return String(data: rawData, encoding: .utf8)
    }
    
    var object : T?
    
    init(data : Data) {
        rawData = data
        object = try? JSONDecoder().decode(T.self, from: rawData!)
    }
    
}
