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

    var movementDelegate: AgentMovementDelegate?
    var delegate: AgentDelegate?

    var map: Map

    var location: Slot {
        get {
            return _location
        }
        set {
            _location = newValue
        }
    }
    private var _location: Slot
    
    var cheasts: [Cheast]
    var door: Slot?

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
    
    init(map: Map, startLocation location: Slot) {
        self.map = map

        bags = []
        cheasts = []
        distributedBags = []

        _location = location
        _location.set(type: .pirate)
        defaultLocation = _location
    }

    var aux = true
    func start() {
        if !stopped {
//            print("Agent started")
            switchEvent(evt: .start)
        } else {
            if aux {
//            print("Agent REstartado")
            switchEvent(evt: .start)
                aux.toggle()
            }
        }
    }

//    func stop() {
//        print("Agent stoped\n")
//        stopped = true
//    }

    func reset() {
//        print("Agent Resetado\n")
        redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
        moveView(to: defaultLocation)
        location = defaultLocation
        stopped = true
//        bags.removeAll()
//        cheasts.removeAll()
//        door = nil
//        distributedBags.removeAll()
        next()
    }

    func colectBag() {
        let bag = coletarBag(location)
        self.bags.append(bag)
        self.checkIfisCompleted()
    }
    
}
