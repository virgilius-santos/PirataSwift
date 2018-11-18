//
//  Slot.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct Slot: Hashable, Equatable {
    
    private(set) var type: ImageType
    private(set) var index: Index
    private(set) var isBusy: Bool = false
    
    init(index: Index, type: ImageType = .Empty) {
        self.type = type
        self.index = index
    }

    mutating func set(type: ImageType = .Empty) {
        self.type = type
    }

    mutating func setBusy() {
        self.isBusy = true
    }
    
    static func == (lhs: Slot, rhs: Slot) -> Bool {
        return ((lhs.index == rhs.index) && (lhs.type == rhs.type))
    }
}
