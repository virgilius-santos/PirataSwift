//
//  AgentData.swift
//  Pirata
//
//  Created by Virgilius Santos on 24/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct AgentData {

    var cheasts: [Cheast] = []
    var distributedBags: [[Bag]] = []

    var defaultLocation: Slot!
    var location: Slot!
    var door: Slot?
    let speed: Double = 0.5
    
    var points: Int = 0

    var bags: [Bag] = []

    var totalCoins: Int { bags.reduce(0, { $0 + $1.valor}) * 10 }
    var totalPoints: Int { totalCoins + points  }

    let genesis: Int

    init(genesis: Int) {
        self.genesis = genesis
    }
    
    mutating func clear() {
        cheasts.removeAll()
        distributedBags.removeAll()

        location = defaultLocation
        door = nil

        points = 0
        bags.removeAll()

    }
}
