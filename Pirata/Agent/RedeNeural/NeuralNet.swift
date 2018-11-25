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

    var _lastDirection: Direction?

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

    var genetic = NeuralGenetic()

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

        genetic.popular(weight: qtdWeights)
    }

    func reset() {
        genetic.popular(weight: qtdWeights)
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

    func getMovement(fromSlots slots: Map.RegionList) -> Agent.Movement? {

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

        let movementKey = movements.enumerated().max(by: {$0.element < $1.element})
        let directionKey = directions
            .enumerated()
            .filter({$0.offset != getToogleDirection()?.rawValue})
            .max(by: {$0.element < $1.element})

        let movement = Action(rawValue: movementKey!.offset)

        let direction = Direction(rawValue: directionKey!.offset)
        _lastDirection = direction

        return (movement!, direction!)

    }

    func getToogleDirection() -> Direction? {
        guard let dir = _lastDirection else {
            return nil
        }
        switch dir {
        case .left:
            return .right
        case .right:
            return .left
        case .down:
            return .up
        case .up:
            return .down
        }
    }
}

extension NeuralNet: FilterAnimation {
    var canShow: Bool { return genetic.canShow }
}
