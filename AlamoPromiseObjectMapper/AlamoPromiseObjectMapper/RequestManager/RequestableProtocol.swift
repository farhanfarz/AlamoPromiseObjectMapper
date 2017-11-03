//
//  RequestableProtocol.swift
//  AlamoPromiseObjectMapper
//
//  Created by Farhan Yousuf on 10/30/17.
//  Copyright © Farhan Yousuf. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol Requestable: URLRequestConvertible {
    var method: Alamofire.HTTPMethod { get }
    
    var `protocol`: String { get }
    var baseUrl: String { get }
    var deployment: String { get }
    var path: String { get }
    
    var url: URL { get }
    var parameters: Parameters? { get }
    
    @discardableResult func call<T: BaseMappable>(with responseObject:@escaping (DataResponse<T>) -> Void) -> DataRequest
    @discardableResult func call<T: BaseMappable>(with responseArray:@escaping (DataResponse<[T]>) -> Void) -> DataRequest
}
