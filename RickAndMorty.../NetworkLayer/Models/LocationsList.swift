//
//  LocationsList.swift
//  RickAndMorty...
//
//  Created by Андрей on 23.06.2021.
//

import Foundation

struct LocationsList {
    
    var infoLoc: LocationsListInfo
    var resultsLoc: [Location]
}

extension LocationsList: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        infoLoc = LocationsListInfo(JSON: JSON["info"] as! [String : AnyObject])!
        resultsLoc = [Location(identifier: 0,
                                name: "",
                                type: "",
                                dimension: ""
                             )]
        if let arrayLoc = JSON["results"] as? NSArray {
            resultsLoc = []
            for obj in arrayLoc {
                if let location = Location(JSON: obj as! [String : AnyObject]) {
                    resultsLoc.append(location)
                }
            }
        }
    }
}

struct LocationsListInfo {
    var countLoc: Int
    var pagesLoc: Int
    var nextLoc: String?
    var prevLoc: String?
}

extension LocationsListInfo: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        countLoc = JSON["count"] as? Int ?? 0
        pagesLoc = JSON["pages"] as? Int ?? 0
        nextLoc = JSON["next"] as? String
        prevLoc = JSON["prev"] as? String
    }
}
