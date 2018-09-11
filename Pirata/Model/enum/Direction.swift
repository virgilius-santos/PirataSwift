//
//  Direction.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

enum Direction: Int {
    case horizontal, vertical
    
    func internWall(row: Int, col: Int, indice: Int) -> Index {
        switch self {
        case .horizontal:
            return Index(col: col+indice, row: row)
        case .vertical:
            return Index(col: col, row: row+indice)
        }
    }
}
