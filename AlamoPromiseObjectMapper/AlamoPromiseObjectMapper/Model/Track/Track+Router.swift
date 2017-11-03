//
//  Track+Router.swift
//  SampleAlamoMapper
//
//  Created by Farhan Yousuf on 28/10/17.
//  Copyright © Farhan Yousuf. All rights reserved.
//

import Foundation
import Alamofire

extension Track {
    enum Router: Requestable {
        
        case search(with: String)
        
        var method: Alamofire.HTTPMethod {
            return .get
        }
        
        var path: String {
            switch self {
            case .search:
                return "search"
            }
        }
        
        var parameters: Parameters? {
            switch self {
                case .search(let text): return ["term": text, "media": "music"]
            }
        }
    }
}
