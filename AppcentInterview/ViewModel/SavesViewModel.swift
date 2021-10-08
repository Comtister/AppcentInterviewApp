//
//  SavesViewModel.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 7.10.2021.
//

import Foundation
import RxSwift

class SavesViewModel: NetworkableViewModel {
    private let _gamesState : PublishSubject<Bool>
    private let _loadingState : PublishSubject<Bool>
    
    var gamesState : Observable<Bool>{
        return _gamesState
    }
    
    var loadingState : Observable<Bool>{
        return _loadingState
    }
    
    var currentData : [Game] = [Game]()
    
    override init() {
        self._loadingState = PublishSubject<Bool>()
        self._gamesState = PublishSubject<Bool>()
    }
    
    func getDatas(){
        
        _loadingState.onNext(true)
       let result = DatabaseManager.shared.getAllData(object: Game.self)
        currentData = result.objects(at: IndexSet(result.startIndex..<result.endIndex))
        _gamesState.onNext(true)
        _loadingState.onNext(false)
        
    }
    
   
}
