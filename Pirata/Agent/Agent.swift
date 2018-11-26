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

    public typealias Movement = (action: Action, direction: Direction)

    weak var neuralNet: NeuralNet!
    weak var agentMap: AgentMap!

    weak var delegate: AgentDelegateInfo?
    weak var mapAnimations: AgentMapAnimations?
    weak var movementAnimations: AgentMovementAnimations?

    var location: Slot {
        get {
            return agentData.location
        }
        set {
            agentData.location.index = newValue.index
        }
    }

    var agentData: AgentData

    var eventoAtual: EventNeuralType {
        get { return _eventoAtual }
        set {
            switch (_eventoAtual, newValue) {
            case (.erro, .comecar):
                _eventoAtual = newValue

            case (.erro, _):
                return
                
            default:
                _eventoAtual = newValue
            }
        }
    }
    private var _eventoAtual: EventNeuralType

    init(map: AgentMap, startLocation location: Slot, brain: NeuralNet, genesis: Int) {
        neuralNet = brain

        agentMap = map

        _eventoAtual = .comecar

        agentData = AgentData(genesis: genesis)
        agentData.location = location
        agentData.location.set(type: .pirate)
        agentData.defaultLocation = agentData.location
    }

    func start() -> Guarantee<EventNeuralType> {
       return DispatchQueue.global(qos: .utility).async(.promise) {
            self.switchEvent()
            return self.finished()
        }
    }

    func finished() -> EventNeuralType {
        return self.eventoAtual
    }

    func reset() {
        eventoAtual = .erro
        agentData.clear()
    }

    func moveToDefaultLocation() {
        moveView(to: agentData.defaultLocation)
    }
}
