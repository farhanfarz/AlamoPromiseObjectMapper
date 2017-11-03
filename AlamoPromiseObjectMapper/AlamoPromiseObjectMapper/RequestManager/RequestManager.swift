//
//  RequestManager.swift
//  SampleAlamoMapper
//
//  Created by Farhan Yousuf on 28/10/17.
//  Copyright © Farhan Yousuf. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import PromiseKit

class RequestManager {
    
    static let shared = RequestManager()
    var manager: Alamofire.SessionManager
    
    private init() {
        let configuration = URLSessionConfiguration.default
        let allHeaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        configuration.httpAdditionalHeaders = allHeaders
        self.manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func call(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return manager.request(urlRequest)
    }
}
