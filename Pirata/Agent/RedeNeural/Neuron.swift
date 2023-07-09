//
//  Neuronio.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Neuron {

    public typealias Parameters = [Double]

    var qtdWeights: Int { return 1 + _weights.count}

    private var _weightZero: NeuralNet.Weight = 0
    private var _weights: NeuralNet.Weights = []

    init() {
        randomComplete()
    }

    func randomComplete() {
        _weightZero = NeuralNet.Weight.randomDouble
        _weights.removeAll()
        // 3 pesos (dir, esq, baixo)
        for _ in 0..<4 {
            _weights.append(NeuralNet.Weight.randomDouble)
        }
    }

    func setWeights(_ weights: NeuralNet.Weights) {
        _weightZero = weights.first!
        _weights = Array(weights.dropFirst())
    }

    func weightsCalc(parameters: Parameters) -> Double {
        var value = parameters
            .lazy
            .enumerated()
            .reduce(0) { (result, data) -> Double in

                let (index, parametro) = data
                return result + parametro * _weights[index]
        }

        value += _weightZero
        return value
    }

}
