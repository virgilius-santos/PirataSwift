//
//  Neuronio.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Neuronio {

    var qdtPesos: Int { return 1 + _pesos.count}

    private var _pesoZero: Double = 0
    private var _pesos: [Double] = []

    init() {
        randomComplete()
    }

    func randomComplete() {
        _pesoZero = Double.randomDouble
        _pesos.removeAll()
        for _ in 0...3 {
            _pesos.append(Double.randomDouble)
        }
    }

    func setPesos(_ pesos: [Double]) {
        var p = pesos
        _pesoZero = p.removeFirst()
        _pesos = p
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
