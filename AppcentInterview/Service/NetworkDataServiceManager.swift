//
//  NetworkDataServiceManager.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 3.10.2021.
//

import Foundation
import Alamofire

class NetworkDataServiceManager{
    
    static let shared : NetworkDataServiceManager = NetworkDataServiceManager()
    private let session : Session
    
    private init(){
        let sessionConfig = Session.default.sessionConfiguration
        sessionConfig.timeoutIntervalForRequest = 6
        self.session = Session(configuration:sessionConfig)
    }
    
    func sendRequest<T : Codable>(request : NetRequestModel , completion : @escaping (Result<T,NetworkDataError>) -> Void){
        
        do{
            try session.request(request: request).validate(statusCode: 200...300).response(queue: .global(qos: .userInitiated), completionHandler: { (response) in
                
                switch response.result{
                case .success(let data) :
                    
                    guard let data = data else { completion(Result.failure(NetworkDataError.DataNotValid)) ; return }
                    
                    let responseModel = NetResponseModel<T>(data: data)
                    guard let dataObject = responseModel.object else { completion(Result.failure(NetworkDataError.DataParsingError)); return }
                    
                    completion(Result.success(dataObject))
                    
                case .failure(let error) :
                    
                    let generalizedError = error.responseCode == nil ? NetworkDataError.ConnectionError : NetworkDataError.ServerError
                    completion(Result.failure(generalizedError))
                
                }
                
            })
        }catch{
            completion(Result.failure(NetworkDataError.ConnectionError))
        }
        
    }
    
}
