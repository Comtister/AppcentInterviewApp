//
//  Errors.swift
//  AppcentInterview
//
//  Created by Oguzhan Ozturk on 3.10.2021.
//

import Foundation

enum NetworkDataError : String, Error{
   
    case ConnectionError = "Connection Fail"
    case ServerError = "Server Error"
    case DataNotValid = "No Data"
    case DataParsingError = "Data Parsing Error"
}

enum ImageDownloadError : String , Error{
    
    case DownloadError = "Connection Fail"
    case DataError = "Data Error"
    
}


