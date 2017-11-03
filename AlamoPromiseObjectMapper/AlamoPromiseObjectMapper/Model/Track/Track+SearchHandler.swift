//
//  Track+SearchHandler.swift
//  AlamoPromiseObjectMapper
//
//  Created by Farhan Yousuf on 28/10/17.
//  Copyright © Farhan Yousuf. All rights reserved.
//

import Foundation
import ObjectMapper

extension Track {
    
    class SearchHandler: Mappable {
    
        var count = 0
        var tracks: [Track] = []
        
        required init?(map: Map) {
            
        }
        
        func mapping(map: Map) {
            count <- map["resultCount"]
            tracks <- map["results"]
        }
    }
}
