//
//  DetailViewModel.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 6.10.2021.
//

import Foundation
import RxSwift

class DetailViewModel: NetworkableViewModel {
    
    enum ChangeState {
        case saved , deleted
    }
    
    func getGameDetail(id : Int) -> Single<Game>{
    
        return Single.create { (single) -> Disposable in
            let disposable = Disposables.create()
            let request = GameDetailRequest(gameID: id)
            
            NetworkDataServiceManager.shared.sendRequest(request: request) { [weak self] (result : Result<Game,NetworkDataError>) in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let gameDetail) :
                        single(.success(gameDetail))
                    case .failure(let error) :
                        single(.failure(error))
                    }
                }
            }
            return disposable
        }
    }
    
    func isFavorite(id : Int) -> Bool{
        let data = DatabaseManager.shared.getById(object: Game.self, id: id)
        return data != nil ? true : false
    }
   
    func changeSaveState(game : Game) -> Single<ChangeState>{
        return Single.create { (single) -> Disposable in
            let disposable = Disposables.create()
            
            if !DatabaseManager.shared.isDataSaved(object: Game.self, id: game.id){
                let realmGame = game.copyValues()
                DatabaseManager.shared.saveObject(object: realmGame) { (error) in
                    if let error = error{
                        single(.failure(error))
                        return
                    }
                    single(.success(.saved))

                }
                
            }else{
                let realmGame = DatabaseManager.shared.getById(object: Game.self, id: game.id)
                if let realmGame = realmGame{
                    DatabaseManager.shared.deleteObject(object: realmGame ) { (error) in
                        if let error = error{
                            single(.failure(error))
                            return
                        }
                        single(.success(.deleted))
                    }
                }
            }
            
            return disposable
        }
    }
    
}
