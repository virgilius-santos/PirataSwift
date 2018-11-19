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

    var qtdPesos: Int {
        let qtd = [neuronios,
                   neuroniosMovimento,
                   neuroniosDirecao
            ].lazy
            .flatMap({$0})
            .map({$0.qdtPesos})
            .reduce(0, +)
        return qtd
    }
    private var neuronios: [Neuronio] = []

    private var neuroniosMovimento: [Neuronio] = []

    private var neuroniosDirecao: [Neuronio] = []

    var genetic = NeuralGenetic()

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
        genetic.popular(pesos: qtdPesos)
    }

    func setPesos() {
        let pesos = genetic.getPesos()
        var start = 0
        var end = 0

        [
            neuronios,
            neuroniosMovimento,
            neuroniosDirecao
            ]
            .lazy
            .flatMap({$0})
            .forEach { (neuronio) in
                end += neuronio.qdtPesos
                let pesosDosNeuronios = Array(pesos[start..<end])
                neuronio.setPesos(pesosDosNeuronios)
                start = end
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

        let movimentoKey = movimentos.enumerated().max(by: {$0.element < $1.element})
        let direcaoKey = direcoes.enumerated().max(by: {$0.element < $1.element})

        let movimento = Acao(rawValue: movimentoKey!.offset)
        let direcao = Direction(rawValue: direcaoKey!.offset)

        return (movimento!, direcao!)
    }
}
