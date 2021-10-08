//
//  GamesRequest.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 4.10.2021.
//

import Foundation

class GamesRequest : NetRequestModel{
    
    var page : Int
    
        override var baseUrl: String{
        return "https://api.rawg.io/api/"
    }
    
    override var path: String{
        return "games"
    }
    
    override var body: [String : String]?{
        return ["key" : "221049d602e04ea69258e08b0e8e5810" , "page" : String(page)]
    }
    
    init(page : Int) {
        self.page = page <= 0 ? 1 : page
    }
    
}

