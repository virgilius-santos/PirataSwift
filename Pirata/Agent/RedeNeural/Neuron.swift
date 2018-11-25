//
//  Neuronio.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Neuron {

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
        for _ in 0..<3 {
            _weights.append(NeuralNet.Weight.randomDouble)
        }
    }

    func setWeights(_ weights: NeuralNet.Weights) {
        var p = weights
        _weightZero = p.removeFirst()
        _weights = p
    }

    func weightsCalc(parametros: [Double]) -> Double {
        var value = parametros
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
