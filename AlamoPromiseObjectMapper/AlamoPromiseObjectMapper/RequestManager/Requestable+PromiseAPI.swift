//
//  Requestable+PromiseAPI.swift
//  AlamoPromiseObjectMapper
//
//  Created by Farhan Yousuf on 28/10/17.
//  Copyright © Farhan Yousuf. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import PromiseKit
import ObjectMapper

extension Requestable {
    
    func request<T:BaseMappable>() -> Promise<T> {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return Promise { (fulfil, reject) -> Void in
            call { (response: DataResponse<T>) in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                guard response.error == nil else {
                    reject(response.error!)
                    return
                }
                
                guard let value = response.value else {
                    let error = NSError(domain: "Unknown Error", code: 0, userInfo: nil)
                    reject(error)
                    return
                }
                
                fulfil(value)
            }
        }
    }
    
    func request<T:BaseMappable>() -> Promise<[T]> {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        return Promise { (fulfil, reject) -> Void in
            call { (response: DataResponse<[T]>) in
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                guard response.error == nil else {
                    reject(response.error!)
                    return
                }
                
                guard let value = response.value else {
                    let error = NSError(domain: "Unknown Error", code: 0, userInfo: nil)
                    reject(error)
                    return
                }
                
                fulfil(value)
            }
        }
    }
}
