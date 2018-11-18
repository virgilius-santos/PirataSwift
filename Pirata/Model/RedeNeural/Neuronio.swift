//
//  Neuronio.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Neuronio {

    private var _pesoZero: Double = 0
    private var _pesos: [Double] = []

    var randomDouble: Double {
        let gen = ClosedRange<Double>(uncheckedBounds: (-1,1))
        let val = Double.random(in: gen)
        return val
    }

    init() {
        randomComplete()
    }

    func randomComplete() {
        _pesoZero = randomDouble
        for _ in 0...3 {
            _pesos.removeAll()
            _pesos.append(randomDouble)
        }
    }

    func setPesos(pesos: [Double] = []) {
        if pesos.count != _pesos.count + 1 {
            randomComplete()
        } else {
            var p = pesos
            _pesoZero = p.removeFirst()
            _pesos = p
        }
    }

    func calculaPesos(parametros: [Double]) -> Double {
        var valor = parametros
            .lazy
            .enumerated()
            .reduce(0) { (result, dado) -> Double in

                let (index, parametro) = dado
                return result + parametro * _pesos[index]
        }

        valor += _pesoZero
        return valor
    }

}
