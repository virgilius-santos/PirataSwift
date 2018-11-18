//
//  Agent.swift
//  Pirata
//
//  Created by Virgilius Santos on 08/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Agent {

    var redeNeural = RedeNeural()

    var defaultLocation: Slot

    var movementDelegate: AgentMovementDelegate?
    var delegate: AgentDelegate?

    var map: Map

    var location: Slot {
        get {
            return _location
        }
        set {
            if !stopped {
                _location = newValue
            } else {
                _location = defaultLocation
            }
        }
    }
    private var _location: Slot
    
    var cheasts: [Cheast]
    var door: Slot?
    
    var holeJumpeds: Int = 0 {
        didSet {
            updateValues()
        }
    }
    
    var bags: [Bag] {
        didSet {
            updateValues()
        }
    }
    
    var distributedBags: [[Bag]]
    
    var totalCoins: Int {return self.bags.reduce(0, { $0 + $1.valor}) * 10}

    var stopped: Bool = false

    var isCompleted: Bool = false

    var speed: Double = 0.5
    
    init(map: Map, startLocation location: Slot) {
        self.map = map

        bags = []
        cheasts = []
        distributedBags = []

        _location = location
        _location.set(type: .pirate)
        defaultLocation = _location
    }

    func start() {
        print("Agent started\n")
        stopped = false
        switchEvent(evt: .start)
    }

    func stop() {
        print("Agent stoped\n")
        stopped = true
    }

    func reset() {
        bags.removeAll()
        cheasts.removeAll()
        door = nil
        distributedBags.removeAll()
        location = defaultLocation
    }
    
    func colectBag() {
        coletarBag(location) { (bag) in
            self.bags.append(bag)
            self.checkIfisCompleted()
        }
    }
    
}
