//
//  Requestable+AlamoObjectMapper.swift
//  AlamoPromiseObjectMapper
//
//  Created by Farhan Yousuf on 10/30/17.
//  Copyright © Farhan Yousuf. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

extension Requestable {
    
    var `protocol`: String {
        return "http"
    }
    
    var baseUrl: String {
        return "itunes.apple.com"
    }

    var deployment: String {
        return ""
    }
    
    var url: URL {
        return URL(string: "\(`protocol`)://\(baseUrl)\(deployment)") ?? URL(fileURLWithPath: "")
    }
    
    func call<T: BaseMappable>(with responseObject:@escaping (DataResponse<T>) -> Void) -> DataRequest {
        return RequestManager.shared.call(self).responseObject(completionHandler: responseObject).validateResponse()
    }
    
    func call<T: BaseMappable>(with responseArray:@escaping (DataResponse<[T]>) -> Void) -> DataRequest {
        return RequestManager.shared.call(self).responseArray(completionHandler: responseArray).validateResponse()
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method, headers: RequestManager.shared.manager.session.configuration.httpAdditionalHeaders as? HTTPHeaders ?? [:])
        return try Alamofire.URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
