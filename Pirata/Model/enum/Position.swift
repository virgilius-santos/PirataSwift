//
//  Position.swift
//  Pirata
//
//  Created by Virgilius Santos on 08/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation


enum Position: Int {
    case left, right, up, down
    
    func sideWall(limit: Int, value: Int) -> Index {
        switch self {
        case .left:
            return Index(col: 0, row: value)
        case .right:
            return Index(col: limit-1, row: value)
        case .up:
            return Index(col: value, row: 0)
        case .down:
            return Index(col: value, row: limit-1)
        }
    }
    
    func door(limit: Int, value: Int) -> Index {
        switch self {
        case .left:
            return Index(col: 0, row: value)
        case .right:
            return Index(col: limit-1, row: value)
        case .up:
            return Index(col: value, row: 0)
        case .down:
            return Index(col: value, row: limit-1)
        }
    }
    
    func cheast(limit: Int, value: Int) -> Index {
        switch self {
        case .left:
            return Index(col: 1, row: value)
        case .right:
            return Index(col: limit-2, row: value)
        case .up:
            return Index(col: value, row: 1)
        case .down:
            return Index(col: value, row: limit-2)
        }
    }
}
