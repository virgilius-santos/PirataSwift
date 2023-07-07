//
//  Index.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct Index: Hashable, Equatable {
    var col: Int
    var row: Int
    
    init(col: Int, row: Int) {
        self.col = col
        self.row = row
    }
    
    static func == (lhs: Index, rhs: Index) -> Bool {
        return ((lhs.col == rhs.col) && (lhs.row == rhs.row))
    }
}
