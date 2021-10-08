//
//  GameDetailRequest.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 6.10.2021.
//

import Foundation

class GameDetailRequest: NetRequestModel {
    
    var gameID : Int
    
    override var baseUrl: String{
        return "https://api.rawg.io/api/"
    }
    
    override var path: String{
        return "games/\(gameID)"
    }
    
    override var body: [String : String]?{
        return ["key" : "221049d602e04ea69258e08b0e8e5810"]
    }
    
    init(gameID : Int) {
        self.gameID = gameID
    }
    
}
