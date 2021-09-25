//
//  Model.swift
//  RickAndMorty...
//
//  Created by Андрей on 15.06.2021.
//

import UIKit

struct MainModel {
    
    var image: UIImage
    var type: MainRow
}

enum MainRow: String {
    
    case characters
    case locations
    case episodes
}
