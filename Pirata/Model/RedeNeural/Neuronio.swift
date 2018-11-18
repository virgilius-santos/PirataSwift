//
//  Neuronio.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct Neuronio {

    var pesoZero: Double = 0
    var pesos: [Double] = []

    var randomDouble: Double {
        let gen = ClosedRange<Double>(uncheckedBounds: (-1,1))
        let val = Double.random(in: gen)
        return val
    }

    init() {
        setPesos()
    }

    mutating func setPesos(pesos: [Double] = []) {
        self.pesoZero = randomDouble
        for _ in 0...3 {
            self.pesos.append(randomDouble)
        }
    }

    func calculaPesos(parametros: [Double]) -> Double {
        var valor = parametros
            .lazy
            .enumerated()
            .reduce(0) { (result, dado) -> Double in

                let (index, parametro) = dado
                return result + parametro * self.pesos[index]
        }

        valor += self.pesoZero
        return valor
    }

}
