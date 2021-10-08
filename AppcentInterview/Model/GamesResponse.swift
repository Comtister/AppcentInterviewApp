//
//  GamesResponse.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 4.10.2021.
//

import Foundation

class GamesResponse : Codable{
    
    var nextPageUrl : String?
    var previousPageUrl : String?
    var games : [Game]
    
    init() {
        self.games = [Game]()
    }
    
    enum CodingKeys : String , CodingKey{
        case nextPageUrl = "next"
        case previousPageUrl = "previous"
        case games = "results"
    }
    
}
