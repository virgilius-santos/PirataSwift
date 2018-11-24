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


    var faults: Int = 0
    var holeJumpeds: Int = 0
    var bags: [Bag] = []


    var totalCoins: Int {
        return self.bags.reduce(0, { $0 + $1.valor}) * 10
    }

    var totalPoints: Int {
        let coins = self.totalCoins
        let general = coins
            + self.holeJumpeds * 30
            - self.faults
        return general
    }

    mutating func clear() {
        cheasts.removeAll()
        distributedBags.removeAll()

        location = defaultLocation
        door = nil

        faults = 0
        holeJumpeds = 0
        bags.removeAll()

    }
}
