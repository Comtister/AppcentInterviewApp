//
//  NetworkMonitor.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 3.10.2021.
//

import Foundation
import Network

class NetworkMonitor{
    
    static let networkMonitor = NetworkMonitor()
    
    private let queue = DispatchQueue.global(qos: .background)
    let monitor : NWPathMonitor
    
    var isConnected : Bool{
        get{
            if monitor.currentPath.status == .satisfied{
                return true
            }else{
                return false
            }            
        }
    }
    
    private init(){
        
        self.monitor = NWPathMonitor()
        
    }
    
    func startMonitoring(){
        
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
           
            
            let networkStateNotification = Notification(name: Notification.Name.NetworkStateNotification,userInfo: ["state" : self?.isConnected as Any])
            NotificationCenter.default.post(networkStateNotification)
            
        }
        
    }
    
    func stopMonitoring(){
        monitor.cancel()
    }
    
}
