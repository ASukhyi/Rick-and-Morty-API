//
//  CharactersList.swift
//  RickAndMorty...
//
//  Created by Андрей on 23.06.2021.
//

import Foundation

struct CharactersList {
    
    var info: CharacterListInfo
    var results: [Character]
}

extension CharactersList: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        info = CharacterListInfo(JSON: JSON["info"] as! [String : AnyObject])!
        results = [Character(identifier: 0,
                             name: "test",
                             status: .alive,
                             gender: .female,
                             species: "",
                             imageUrl: "",
                             origin: Origin(name: "", url: ""),
                             location: LocationOfCharacter(name: "", url: ""))]
        if let array = JSON["results"] as? NSArray {
            results = []
            for obj in array {
                if let character = Character(JSON: obj as! [String : AnyObject]) {
                    results.append(character)
                }
            }
        }
    }
}

struct CharacterListInfo {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}

extension CharacterListInfo: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        count = JSON["count"] as? Int ?? 0
        pages = JSON["pages"] as? Int ?? 0
        next = JSON["next"] as? String
        prev = JSON["prev"] as? String
    }
}
