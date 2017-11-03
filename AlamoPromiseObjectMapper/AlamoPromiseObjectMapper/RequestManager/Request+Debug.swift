//
//  Request+Debug.swift
//  SampleAlamoMapper
//
//  Created by Farhan Yousuf on 28/10/17.
//  Copyright © Farhan Yousuf. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyBeaver

enum ServiceError: Error {
    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case unsuppotedURL
    case blocked
    case reportedByOthers
}

public extension Alamofire.Request {
    
    typealias Log = SwiftyBeaver
    
    @discardableResult func debug() -> Self {
        Log.info(debugDescription)
        return self
    }
}

public extension Alamofire.DataRequest {
    
    @discardableResult
    func validateResponse() -> Self {
        return self.validate({ [weak self] (request, response, data) -> Alamofire.Request.ValidationResult in
            
            //get status code from server
            let code = response.statusCode
            
            //check the request url
            let requestURL = String(describing: request?.url?.absoluteString ?? "NO URL")
            
            //check if response is empty
            guard let data = data, let string = String(data: data, encoding: .utf8) else {
                Log.warning(String(code) + " " + requestURL + "\nEmpty response")
                return .success
            }
            
            var result: Alamofire.Request.ValidationResult = .success
            //check if response is html
            if (response.allHeaderFields["Content-Type"] as? String)?.contains("text/html") == true {
                Log.info(String(code) + " " + requestURL + "\n\(string)")
                result = .failure(ServiceError.invalidResponse)
            }
            else {
                Log.info(String(code) + " " + requestURL + "\n\(string)")
                if code != 200 {
                    guard let welf = self else {
                        result = .failure(ServiceError.unknownError)
                        return result
                    }
                    result = .failure(welf.checkErrorCode(code))
                    if code == -1016 || code == 401 {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                            if let json = json as? [String: Any], let status = json["status"] as? Int {
                                
                                //create the error object
                                if status == 403 {
                                    result = .failure(ServiceError.reportedByOthers)
                                    // show a popup
                                    
                                }else if status == 401 {
                                    // blocked
                                    
//                                    // show an alert with the message
//                                    var message = json["message"] as? String
                                    result = .failure(ServiceError.blocked)
                                }
                            }
                        } catch {
                            Log.error(error)
                            result = .failure(ServiceError.invalidResponse)
                        }
                    }
                }else {
                    result = .success
                }
            }
            return result
        }).validate().debug()
    }
    
    private func checkErrorCode(_ errorCode: Int) -> ServiceError {
        switch errorCode {
        case 400:
            return .invalidRequest
        case 401:
            return .invalidCredentials
        case 404:
            return .notFound
        case 1005:
            return .connectionError
        case -1016:
            return .invalidCredentials
        default:
            return .unknownError
        }
    }
}
