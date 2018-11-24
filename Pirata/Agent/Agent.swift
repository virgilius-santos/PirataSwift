//
//  Agent.swift
//  Pirata
//
//  Created by Virgilius Santos on 08/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation
import PromiseKit

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

    var currentEvent: EventNeuralType {
        get { return _currentEvent }
        set {
            switch (_currentEvent, newValue) {
            case (.error, .start):
                _currentEvent = newValue
                break
            case (.error, _):
                return
            default:
                _currentEvent = newValue
                break
            }
        }
    }
    private var _currentEvent: EventNeuralType

    init(map: AgentMap, startLocation location: Slot, cerebro: RedeNeural, pesos: [Double]) {
        redeNeural = cerebro

        agentMap = map

        _currentEvent = .start(pesos)

        agentData = AgentData()
        agentData.location = location
        agentData.location.set(type: .pirate)
        agentData.defaultLocation = agentData.location
    }

    func start() {
       DispatchQueue.global(qos: .utility).async {
            self.switchEvent()
            self.finished()
        }
    }

    func finished() {
        let evt: EventNeuralType = DispatchQueue.main.async(.promise) {
            return self.currentEvent
        }.wait()

        if case .finished = evt {
            next()
        }
    }

    func reset() {
        currentEvent = .error
        agentData.clear()
    }

    func moveToDefaultLocation() {
        moveView(to: agentData.defaultLocation)
    }
}
