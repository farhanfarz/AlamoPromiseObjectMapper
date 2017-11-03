//
//  TracksViewController.swift
//  AlamoPromiseObjectMapper
//
//  Created by Farhan Yousuf on 28-10-17.
//  Copyright © 2017 Farhan Yousuf. All rights reserved.
//

import UIKit
import PromiseKit
import ObjectMapper

class TracksViewController: UITableViewController {    
    
    var tracks = [Track]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView?.reloadData()
            }
        }
    }
}

extension TracksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        firstly { () -> (Promise<Track.SearchHandler>) in
            Track.Router.search(with: text).request()
            }.then { [weak self] (result:Track.SearchHandler ) -> Void in
                self?.tracks = result.tracks
            }.catch { error in
                // do something like pop an alert
        }
    }
}

extension TracksViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseIdentifier) as? TrackCell else { return UITableViewCell() }
        cell.track = tracks[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
