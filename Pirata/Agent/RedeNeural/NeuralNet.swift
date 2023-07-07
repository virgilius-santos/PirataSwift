//
//  RedeNeural.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class NeuralNet {

    public typealias Weights = [Weight]
    public typealias Weight = Double

    private var lastDirection: Direction = .none

    var neuron: Neuron { return Neuron() }

    var qtdWeights: Int {
        let qtd = [intermediateNeuron,
                   movementeNeurons,
                   directionNeurons
            ].lazy
            .flatMap({$0})
            .map({$0.qtdWeights})
            .reduce(0, +)
        return qtd
    }

    private var intermediateNeuron: [Neuron] = []

    private var movementeNeurons: [Neuron] = []

    private var directionNeurons: [Neuron] = []

    init() {

        // 3 neuronios de entrada (dir, esq, baixo)
        for _ in 0..<3 {
            intermediateNeuron.append(neuron)
        }

        // dois neuronios de movimento (anda pula)
        for _ in 0..<2 {
            movementeNeurons.append(neuron)
        }
        // tres neuronios de saida (dir, esq, baixo)
        for _ in 0..<3 {
            directionNeurons.append(neuron)
        }
    }

    func reset() {
        actions = defaultActions
    }
    
    func setWeights(_ weights: Weights) {

        var start = 0
        var end = 0

        [
            intermediateNeuron,
            movementeNeurons,
            directionNeurons
            ]
            .lazy
            .flatMap({$0})
            .forEach { (neuron) in
                end += neuron.qtdWeights
                let neuronsWeights = Array(weights[start..<end])
                neuron.setWeights(neuronsWeights)
                start = end
        }
    }

    func getMovement(fromSlots slots: Map.RegionList) -> Agent.Movement {

        let input = slots.map({Double($0.type.index)})

        let net1 = intermediateNeuron.map { (neuron) -> Double in
            return neuron.weightsCalc(parameters: input)
        }

        let movements = movementeNeurons.map { (neuron) -> Double in
            return neuron.weightsCalc(parameters: net1)
        }

        let directions = directionNeurons.map { (neuron) -> Double in
            return neuron.weightsCalc(parameters: net1)
        }

        let directionKey = directions
            .enumerated()
            .filter({$0.offset != getToogleDirection().rawValue})
            .max(by: {$0.element < $1.element})

        let action: Action = {
            guard
                let movementKey = movements.enumerated().max(by: {$0.element < $1.element}),
                let action = Action(rawValue: movementKey.offset)
            else {
                return .none
            }
            return action
        }()

        let direction: Direction = {
            guard
                let directionKey = directionKey,
                let direction = Direction(rawValue: directionKey.offset)
            else {
                return .none
            }
            return direction
        }()
        lastDirection = direction

        return (action, direction)

    }

    func getToogleDirection() -> Direction {
        switch lastDirection {
        case .left:
            return .right
        case .right:
            return .left
        case .down:
            return .up
        case .up:
            return .down
        case .none:
            return .none
        }
    }
}
