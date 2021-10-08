//
//  Game.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 4.10.2021.
//

import Foundation
import UIKit
import RealmSwift

class Game : Object , Codable{
    
    @Persisted(primaryKey: true) var id : Int
    @Persisted var name : String
    @Persisted var released : String
    @Persisted var desc : String?
    @Persisted var imageUrl : String
    @Persisted var metacritic : Int?
   
    func copyValues() -> Game{
        let game = Game()
        game.id = self.id
        game.name = self.name
        game.released = self.released
        game.desc = self.desc
        game.imageUrl = self.imageUrl
        game.metacritic = self.metacritic
        return game
    }
    
    enum CodingKeys : String , CodingKey{
        case id , name , released , imageUrl = "background_image" , desc = "description" , metacritic
    }
    
}
