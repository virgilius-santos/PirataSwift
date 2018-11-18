//
//  RedeNeural.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class RedeNeural {

    var neuronio: Neuronio { return Neuronio() }

    private var neuronios: [Neuronio] = []

    private var neuroniosMovimento: [Neuronio] = []

    private var neuroniosDirecao: [Neuronio] = []

    init() {
        for _ in 0...3 {
            neuronios.append(neuronio)
        }
        for _ in 0...1 {
            neuroniosMovimento.append(neuronio)
        }
        for _ in 0...3 {
            neuroniosDirecao.append(neuronio)
        }
    }


    func entrada(slots: [Slot]) -> (acao: Acao, direcao: Direction) {

        let input = slots.map({Double($0.type.index)})

        let rede1 = neuronios.map { (neuronio) -> Double in
            return neuronio.calculaPesos(parametros: input)
        }

        let movimentos = neuroniosMovimento.map { (neuronio) -> Double in
            return neuronio.calculaPesos(parametros: rede1)
        }

        let direcoes = neuroniosDirecao.map { (neuronio) -> Double in
            return neuronio.calculaPesos(parametros: rede1)
        }

        let movimentoKey = movimentos.enumerated().max(by: {$0.offset > $1.offset})
        let direcaoKey = direcoes.enumerated().max(by: {$0.offset > $1.offset})

        let movimento = Acao(rawValue: movimentoKey!.offset)
        let direcao = Direction(rawValue: direcaoKey!.offset)

        print("\(movimento!) \(direcao!)")
        return (movimento!, direcao!)
    }
}
