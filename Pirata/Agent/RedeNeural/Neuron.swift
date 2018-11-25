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

    private var _weightZero: Double = 0
    private var _weights: [Double] = []

    init() {
        randomComplete()
    }

    func randomComplete() {
        _weightZero = Double.randomDouble
        _weights.removeAll()
        // 3 pesos (dir, esq, baixo)
        for _ in 0..<3 {
            _weights.append(Double.randomDouble)
        }
    }

    func setWeights(_ weights: [Double]) {
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
