//
//  Queue.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class DataNode {
    var distance: Int
    var slot: Slot
    var parent: DataNode?
    
    init(slot: Slot, distance: Int = 0, parent: DataNode? = nil) {
        self.slot = slot
        self.distance = distance
        self.parent = parent
    }
}
