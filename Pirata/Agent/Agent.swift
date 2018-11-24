//
//  Agent.swift
//  Pirata
//
//  Created by Virgilius Santos on 08/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Agent {

    public typealias Movement = (acao: Acao, direcao: Direction)

    var redeNeural = RedeNeural()

    var defaultLocation: Slot

    var mapAnimations: AgentMapAnimations?
    var movementAnimations: AgentMovementAnimations?

    var delegate: AgentDelegateInfo?

    var agentMap: AgentMap

    var location: Slot {
        get {
            return _location
        }
        set {
            _location.index = newValue.index
        }
    }
    private var _location: Slot
    
    var cheasts: [Cheast]
    var door: Slot?

    var currentEvent: EventNeuralType!

    var faults: Int = 0 {
        didSet {
            updateValues()
        }
    }

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

    var totalPoints: Int {
        let coins = self.totalCoins
        let general = coins + self.holeJumpeds * 30 + (isCompleted ? 10 : 0) - self.faults
        return general
    }

    var stopped: Bool = false

    var isCompleted: Bool = false

    var speed: Double = 0.5
    
    init(map: AgentMap, startLocation location: Slot) {
        agentMap = map

        bags = []
        cheasts = []
        distributedBags = []

        _location = location
        _location.set(type: .pirate)
        defaultLocation = _location
    }

    func start() {
        stopped = false
        DispatchQueue(label: "Agent").async {
            self.currentEvent = .start
            self.switchEvent()
            self.reset()
        }
    }

    func reset() {
        redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
        moveView(to: defaultLocation)
        location = defaultLocation
        stopped = true
        bags.removeAll()
        cheasts.removeAll()
        door = nil
        distributedBags.removeAll()
        faults = 0
        next()
    }

    func checkIfisCompleted() {
        if agentMap.totalSet * 10 == totalCoins {
            if self.isCompleted != true {
                self.isCompleted = true
            }
        }
    }
    
}
