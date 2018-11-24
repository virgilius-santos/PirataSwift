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

    var redeNeural: RedeNeural

    var mapAnimations: AgentMapAnimations?
    var movementAnimations: AgentMovementAnimations?

    var delegate: AgentDelegateInfo?

    var agentMap: AgentMap

    var location: Slot {
        get {
            return agentData.location
        }
        set {
            agentData.location.index = newValue.index
        }
    }

    var agentData: AgentData

    var currentEvent: EventNeuralType = .start

    init(map: AgentMap, startLocation location: Slot, cerebro: RedeNeural) {
        redeNeural = cerebro

        agentMap = map

        agentData = AgentData()
        agentData.location = location
        agentData.location.set(type: .pirate)
        agentData.defaultLocation = location
    }

    func start() {
        DispatchQueue(label: "Agent").async {
            self.currentEvent = .start
            self.switchEvent()
            self.finished()
        }
    }

    func finished() {
        let total = agentData.totalPoints
        redeNeural.genetic.setarAptidoes(apt: Double(total))
        moveView(to: agentData.defaultLocation)
        agentData.clear()
        next()
    }
    
}
