//
//  MainViewModel.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 4.10.2021.
//

import Foundation
import RxSwift

class MainViewModel : NetworkableViewModel{
    
    enum GamesCollectionState {
        case Fetch , Search , NullSearch
    }
    
    private let _gamesChanges : PublishSubject<GamesCollectionState>
    private let _tableLoadingState : PublishSubject<Bool>
    private let _topGamesLoadingState : PublishSubject<Bool>
    
    var gamesChanges : Observable<GamesCollectionState>{
        return _gamesChanges
    }
    
    var tableLoadingState : Observable<Bool>{
        return _tableLoadingState
    }
    
    var topGamesLoadingState : Observable<Bool>{
        return _topGamesLoadingState
    }
    
    override init() {
        self._gamesChanges = PublishSubject<GamesCollectionState>()
        self._tableLoadingState = PublishSubject<Bool>()
        self._topGamesLoadingState = PublishSubject<Bool>()
    }
    
    var dataFinish : Bool = false
    var searchState : Bool = false
    var request : GamesRequest = GamesRequest(page: 1)
    var currentData : GamesResponse = GamesResponse()
    var tempData : GamesResponse? = GamesResponse()
    var topGames : [Game] = [Game]()
    var searchArray : [Game] = [Game]()
   
    func getGames(){
        
        if dataFinish{
            return
        }
        
        if request.page == 1{
            self._topGamesLoadingState.onNext(true)
        }
                
        self._tableLoadingState.onNext(true)
        NetworkDataServiceManager.shared.sendRequest(request: request) { [weak self] (result : Result<GamesResponse,NetworkDataError>) in
            
            switch result{
            case .success(let gameResponse) :
                
                guard let currentData = self?.currentData else {return}
                guard let request = self?.request else {return}
                
                if self?.request.page == 1{
                    self?.topGames.append(contentsOf: gameResponse.games[0...2])
                    DispatchQueue.main.async{  self?._topGamesLoadingState.onNext(false) }
                    gameResponse.games.removeSubrange(0...2)
                }
                
                currentData.games.append(contentsOf: gameResponse.games)
                
                if gameResponse.nextPageUrl != nil{
                    request.page += 1
                }else{
                    self?.dataFinish = true
                }
                
                DispatchQueue.main.async {
                    self?._gamesChanges.onNext(.Fetch)
                    self?._tableLoadingState.onNext(false)
                }
                
            case .failure(let error) :
                DispatchQueue.main.async {
                    self?._gamesChanges.onError(error)
                    self?._tableLoadingState.onNext(false)
                }
            }
            
        }
        
    }
    
    func searchGame(searchText : String){
        
        _tableLoadingState.onNext(true)
        DispatchQueue.global(qos: .userInitiated).async {
            
            if searchText.isEmpty{
                self.currentData.games = self.tempData?.games ?? [Game]()
                self.searchState = false
                DispatchQueue.main.async {
                    self._gamesChanges.onNext(.Search)
                    self._tableLoadingState.onNext(false)
                }
                return
            }
            
            if !self.searchState{
                self.tempData?.games = self.currentData.games
                self.currentData.games.append(contentsOf: self.topGames)
                self.searchArray = self.currentData.games
                self.searchState = true
            }
            
            let findingGames = self.searchArray.filter { (game) -> Bool in
                game.name.contains(searchText)
            }
            
            if findingGames.isEmpty{
                DispatchQueue.main.async {
                    self._gamesChanges.onNext(.NullSearch)
                    self._tableLoadingState.onNext(false)
                }
                return
            }
            
            self.currentData.games = findingGames
            
            DispatchQueue.main.async {
                self._gamesChanges.onNext(.Search)
                self._tableLoadingState.onNext(false)
            }
            
        }
        
    }
    
}
