//
//  NetRequestModel.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 3.10.2021.
//

import Foundation
import Alamofire

class NetRequestModel{
    
    var baseUrl : String{
            return ""
        }
        
        var path : String{
            return ""
        }
        
        var body : [String : String]?{
            return nil
        }
        
        var httpMethod : HTTPMethod{
            return .get
        }
        
        var encoder : URLEncodedFormParameterEncoder{
            return URLEncodedFormParameterEncoder.default
        }
        
        var httpHeaders : HTTPHeaders?{
            return nil
        }
        
        func getRequestUrl() throws -> URLConvertible{
            
            var requestUrl = URL(string: baseUrl)
            requestUrl!.appendPathComponent(path)

            return requestUrl!
            
        }
    
}
