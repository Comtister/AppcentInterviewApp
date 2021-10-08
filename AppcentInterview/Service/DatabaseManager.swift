//
//  DatabaseManager.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 6.10.2021.
//

import Foundation
import RealmSwift

class DatabaseManager{
    
    static let shared : DatabaseManager = DatabaseManager()
    
    private var realm : Realm
    private var observeTokens : [NotificationToken] = [NotificationToken]()
    
    private init(){
        self.realm = try! Realm()
    }
    
    fileprivate func createCustomRealm(config : Realm.Configuration){
            realm = try! Realm(configuration: config)
        }
    
    func saveObject(object : Object , completion : (Error?) -> Void){
        do{
            try realm.write({
                realm.add(object)
            })
            completion(nil)
        }catch{
            completion(error)
        }
        }
    
    func deleteObject(object : Object , completion : (Error?) -> Void){
        do{
            try realm.write({
                realm.delete(object)
            })
            completion(nil)
        }catch{
            completion(error)
        }
        }
    
    func getAllData<T : Object>(object : T.Type) -> Results<T>{
        return realm.objects(T.self)
    }
    
    func getById<T : Object>(object : T.Type , id : Int) -> Object?{
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }
    
    func isDataSaved<T : Object>(object : T.Type , id : Int) -> Bool{
        let data = getById(object: T.self, id: id)
        return data != nil ? true : false
    }
    
    func observeRealm(change : @escaping () -> Void) -> NotificationToken{
            
           let token = realm.observe { (notification, realm) in
                change()
            }
            
            observeTokens.append(token)
            return token
        }
        
    func observeScheme<T : Object>(type : T.Type , change : @escaping (RealmCollectionChange<Results<T>>) -> Void) -> NotificationToken{
            let token = realm.objects(type).observe { (changes) in
               
                change(changes)
                
            }
            observeTokens.append(token)
            return token
        }
        
    func finishObserving(token : NotificationToken){
            token.invalidate()
            var index = 0
            observeTokens.forEach { (savedToken) in
                if savedToken === token{
                    observeTokens.remove(at: index)
                }
               index += 1
            }
            
        }
    //Inner builder class
    class RealmBuilder {
            
            private var config : Realm.Configuration
            private var realmName : String
            
            fileprivate init(realmName : String) {
                self.config = Realm.Configuration.defaultConfiguration
                self.realmName = realmName
                config.fileURL!.deleteLastPathComponent()
                config.fileURL!.appendPathComponent(realmName)
                config.fileURL!.appendPathExtension("realm")
            }
            
            func setConfigs(config : (inout Realm.Configuration) -> Void) -> RealmBuilder{
                config(&self.config)
                return self
            }
            
            func build() throws{
                
                DatabaseManager.shared.createCustomRealm(config: self.config)
                
            }
            
        }
    
}
