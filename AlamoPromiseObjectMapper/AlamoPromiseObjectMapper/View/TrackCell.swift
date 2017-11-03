//
//  TrackCell.swift
//  AlamoPromiseObjectMapper
//
//  Created by Farhan Yousuf on 28-10-17.
//  Copyright © 2017 Farhan Yousuf. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyBeaver

class TrackCell: UITableViewCell {
    
    var track: Track? {
        didSet {
            configureView()
        }
    }
    
    static let reuseIdentifier = "kTrackCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureView()
    }
    
    private func configureView() {
        textLabel?.text = track?.name
        detailTextLabel?.text = track?.collectionName
        
        if let imagePath = track?.imagePath {
            Alamofire.request(imagePath).responseImage { response in
                
                if let image = response.result.value {
                    DispatchQueue.main.async {
                        self.imageView?.image = image
                        self.layoutSubviews()
                    }
                }
            }
        }
    }
}
