//
//  Cheast.swift
//  Pirata
//
//  Created by Virgilius Santos on 10/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct Cheast {
    var slot: Slot
    var isCompleted: Bool { return bags != nil }
    private var bags: [Bag]?
    
    init(_ slot: Slot) {
        self.slot = slot
    }
    
    mutating func add(_ bags: [Bag]) {
        self.bags = bags
    }
}
