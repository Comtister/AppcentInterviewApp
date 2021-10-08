//
//  Session+NetRequest.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 3.10.2021.
//

import Foundation
import Alamofire

extension Session{
    
    func request(request : NetRequestModel) throws -> DataRequest{
        
        return self.request(try! request.getRequestUrl(),method: request.httpMethod,parameters: request.body ,encoder: request.encoder,headers: request.httpHeaders,interceptor: nil,requestModifier: nil)

        
    }
    
}
