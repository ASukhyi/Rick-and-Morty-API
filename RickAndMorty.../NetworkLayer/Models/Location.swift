//
//  Location.swift
//  RickAndMorty...
//
//  Created by Андрей on 23.06.2021.
//

import Foundation

struct Location {
    
    var identifier: Int
    var name: String
    var type: String
    var dimension: String
}


extension Location: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        identifier = JSON["id"] as? Int ?? 0
        name = JSON["name"] as? String ?? String()
        type = JSON["type"] as? String ?? String()
        dimension = JSON["dimension"] as? String ?? String()
    }
}
