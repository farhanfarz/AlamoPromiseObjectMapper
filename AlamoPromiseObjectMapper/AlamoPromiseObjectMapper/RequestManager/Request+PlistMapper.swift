//
//  Request+PlistMapper.swift
//  PropertyDashboard
//
//  Created by Farhan Yousuf on 2/27/18.
//  Copyright © 2018 Emaar Technologies. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import EVReflection
import SwiftyBeaver
//pod 'EVReflection/XML'

extension DataRequest {
    
    enum ErrorCode: Int {
        case noData = 1
        case dataSerializationFailed = 2
    }
    
    internal static func newPlistError(_ code: ErrorCode, failureReason: String) -> NSError {
        let errorDomain = "com.alamofireobjectmapper.error"
        
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let returnError = NSError(domain: errorDomain, code: code.rawValue, userInfo: userInfo)
        
        return returnError
    }
    
    /// Utility function for checking for errors in response
    internal static func checkPlistResponseForError(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        if let error = error {
            return error
        }
        guard let _ = data else {
            let failureReason = "Data could not be serialized. Input data was nil."
            let error = newPlistError(.noData, failureReason: failureReason)
            return error
        }
        return nil
    }
    
    /// Utility function for extracting JSON from response
//    internal static func processPlistResponse(request: URLRequest?, response: HTTPURLResponse?, data: Data?, keyPath: String?) -> Any? {
//
//        let plistResponseSerializer = DataRequest.propertyListResponseSerializer(options: .mutableContainersAndLeaves)
//        let result = plistResponseSerializer.serializeResponse(request, response, data, nil)
//
//        let JSON: Any?
//        if let keyPath = keyPath , keyPath.isEmpty == false {
//            JSON = (result.value as AnyObject?)?.value(forKeyPath: keyPath)
//        } else {
//            JSON = result.value
//        }
//
//        return JSON
//    }
    
    /// BaseMappable Object Serializer
    public static func ObjectMapperPlistSerializer<T: BaseMappable>(_ keyPath: String?, mapToObject object: T? = nil, context: MapContext? = nil) -> DataResponseSerializer<T> {
        
        return DataResponseSerializer { request, response, data, error in
            if let error = checkPlistResponseForError(request: request, response: response, data: data, error: error){
                return .failure(error)
            }
            
            if let data = data, let JSONObject = NSDictionary(xmlData: data) {
                Log.info(JSONObject)
                if let object = object {
                    _ = Mapper<T>(context: context, shouldIncludeNilValues: false).map(JSONObject: JSONObject, toObject: object)
                    return .success(object)
                } else if let parsedObject = Mapper<T>(context: context, shouldIncludeNilValues: false).map(JSONObject: JSONObject){
                    return .success(parsedObject)
                }
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = newPlistError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
    }
    
    /// ImmutableMappable Array Serializer
    public static func ObjectMapperPlistImmutableSerializer<T: ImmutableMappable>(_ keyPath: String?, context: MapContext? = nil) -> DataResponseSerializer<T> {
        return DataResponseSerializer { request, response, data, error in
            if let error = checkPlistResponseForError(request: request, response: response, data: data, error: error){
                return .failure(error)
            }
            
            if let data = data, let JSONObject = NSDictionary(xmlData: data), let parsedObject = (try? Mapper<T>(context: context, shouldIncludeNilValues: false).map(JSONObject: JSONObject)) {
                Log.info(JSONObject)
                return .success(parsedObject)
            }
            
            
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = newPlistError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter queue:             The queue on which the completion handler is dispatched.
     - parameter keyPath:           The key path where object mapping should be performed
     - parameter object:            An object to perform the mapping on to
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    @discardableResult
    public func responsePlistObject<T: BaseMappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperPlistSerializer(keyPath, mapToObject: object, context: context), completionHandler: completionHandler)
    }
    
    @discardableResult
    public func responsePlistObject<T: ImmutableMappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, mapToObject object: T? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperPlistImmutableSerializer(keyPath, context: context), completionHandler: completionHandler)
    }
    
    /// BaseMappable Array Serializer
    public static func ObjectMapperArrayPlistSerializer<T: BaseMappable>(_ keyPath: String?, context: MapContext? = nil) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { request, response, data, error in
            if let error = checkPlistResponseForError(request: request, response: response, data: data, error: error){
                return .failure(error)
            }
            
            if let data = data, let JSONObject = NSDictionary(xmlData: data), let parsedObject = Mapper<T>(context: context, shouldIncludeNilValues: false).mapArray(JSONObject: JSONObject) {
                Log.info(JSONObject)
                return .success(parsedObject)
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = newPlistError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
    }
    
    /// ImmutableMappable Array Serializer
    public static func ObjectMapperImmutableArrayPlistSerializer<T: ImmutableMappable>(_ keyPath: String?, context: MapContext? = nil) -> DataResponseSerializer<[T]> {
        return DataResponseSerializer { request, response, data, error in
            if let error = checkPlistResponseForError(request: request, response: response, data: data, error: error){
                return .failure(error)
            }
            
            if let data = data, let JSONObject = NSDictionary(xmlData: data), let parsedObject = try? Mapper<T>(context: context, shouldIncludeNilValues: false).mapArray(JSONObject: JSONObject) {
                Log.info(JSONObject)

                return .success(parsedObject)
            }
            
            let failureReason = "ObjectMapper failed to serialize response."
            let error = newPlistError(.dataSerializationFailed, failureReason: failureReason)
            return .failure(error)
        }
    }
    
    /**
     Adds a handler to be called once the request has finished. T: BaseMappable
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    @discardableResult
    public func responsePlistArray<T: BaseMappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperArrayPlistSerializer(keyPath, context: context), completionHandler: completionHandler)
    }
    
    /**
     Adds a handler to be called once the request has finished. T: ImmutableMappable
     
     - parameter queue: The queue on which the completion handler is dispatched.
     - parameter keyPath: The key path where object mapping should be performed
     - parameter completionHandler: A closure to be executed once the request has finished and the data has been mapped by ObjectMapper.
     
     - returns: The request.
     */
    @discardableResult
    public func responsePlistArray<T: ImmutableMappable>(queue: DispatchQueue? = nil, keyPath: String? = nil, context: MapContext? = nil, completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.ObjectMapperImmutableArrayPlistSerializer(keyPath, context: context), completionHandler: completionHandler)
    }
}
