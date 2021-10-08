//
//  NetworkableViewModel.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 4.10.2021.
//

import Foundation
import RxSwift

class NetworkableViewModel{
    
    private var _networkState : PublishSubject<Bool>
        
        final var networkState : Observable<Bool>{
            return _networkState
        }
        
        init() {
            self._networkState = PublishSubject<Bool>()
            listenNetworkStatus()
        }
        
        private func listenNetworkStatus(){
            NotificationCenter.default.addObserver(forName: .NetworkStateNotification, object: nil, queue: nil) { [weak self] (notification) in
                guard let userInfo = notification.userInfo as? [String : Bool] else {return}
                self?._networkState.onNext(userInfo["state"]!)
                
            }
        }
    
}
