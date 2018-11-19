//
//  MapSettings.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct MapSettings {
    
    var square: Int
    var cheastNumbers: Int
    var internalWallNumbers: Int
    var internalWallLenght: Int
    var holeNumbers: Int
    var bagsNumbers: Int
    
    init(square: Int) {
        self.square = square
        self.cheastNumbers = 0
        self.internalWallNumbers = 0
        self.internalWallLenght = 5
        self.holeNumbers = 4
        self.bagsNumbers = 5
    }
}
