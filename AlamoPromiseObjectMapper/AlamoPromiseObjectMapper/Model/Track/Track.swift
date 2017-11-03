//
//  Track.swift
//  AlamoPromiseObjectMapper
//
//  Created by Farhan Yousuf on 28-10-17.
//  Copyright © 2017 Farhan Yousuf. All rights reserved.
//

import Foundation
import ObjectMapper

class Track: Mappable {
    
    var name = ""
    var collectionName = ""
    var imagePath = ""

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["trackName"]
        collectionName <- map["collectionName"]
        imagePath <- map["artworkUrl100"]
    }
}
