//
//  Characters.swift
//  RickAndMorty...
//
//  Created by Андрей on 23.06.2021.
//

import Foundation

struct Origin {
    var name: String
    var url: String
}

extension Origin: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String ?? String()
        url = JSON["url"] as? String ?? String()
    }
}

struct LocationOfCharacter {
    var name: String
    var url: String
}

extension LocationOfCharacter: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        name = JSON["name"] as? String ?? String()
        url = JSON["url"] as? String ?? String()
    }
}

enum CharacterStatus: String {
    case alive
    case dead
    case unknown
}

enum CharacterGender: String {
    case female
    case male
    case genderless
    case unknown
}

struct Character {
    
    var identifier: Int
    var name: String
    var status: CharacterStatus
    var gender: CharacterGender
    var species: String
    var imageUrl: String
    var origin: Origin
    var location: LocationOfCharacter
}


extension Character: JSONDecodable {
    
    init?(JSON: [String : AnyObject]) {
        identifier = JSON["id"] as? Int ?? 0
        name = JSON["name"] as? String ?? String()
        switch JSON["status"] as? String ?? String() {
        case "Alive": status = .alive
        case "Dead": status = .dead
        default: status = .unknown
        }
        switch JSON["gender"] as? String ?? String() {
        case "Female": gender = .female
        case "Male": gender = .male
        case "Genderless": gender = .genderless
        default: gender = .unknown
        }
        species = JSON["species"] as? String ?? String()
        imageUrl = JSON["image"] as? String ?? String()
        origin = Origin(JSON: JSON["origin"] as! [String : AnyObject]) ?? Origin(name: "", url: "")
        location = LocationOfCharacter(JSON: JSON["location"] as! [String : AnyObject]) ?? LocationOfCharacter(name: "", url: "")
    }
}
