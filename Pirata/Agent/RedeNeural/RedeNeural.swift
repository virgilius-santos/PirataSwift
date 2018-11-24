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
        let qtd = [neuroniosIntermediarios,
                   neuroniosMovimento,
                   neuroniosDirecao
            ].lazy
            .flatMap({$0})
            .map({$0.qdtPesos})
            .reduce(0, +)
        return qtd
    }
    private var neuroniosIntermediarios: [Neuronio] = []

    private var neuroniosMovimento: [Neuronio] = []

    private var neuroniosDirecao: [Neuronio] = []

    var genetic = NeuralGenetic()

    init() {

        // 3 neuronios de entrada (dir, esq, baixo)
        for _ in 0..<3 {
            neuroniosIntermediarios.append(neuronio)
        }

        // dois neuronios de movimento (anda pula)
        for _ in 0..<2 {
            neuroniosMovimento.append(neuronio)
        }
        // tres neuronios de saida (dir, esq, baixo)
        for _ in 0..<3 {
            neuroniosDirecao.append(neuronio)
        }

        genetic.popular(pesos: qtdPesos)
    }

    func reset() {
        genetic.popular(pesos: qtdPesos)
        actions = defaultActions
    }
    
    func setPesos() {
        let pesos = genetic.getPesosFromNextPopulation()

        if pesos.isEmpty {
            return
        }

        var start = 0
        var end = 0

        [
            neuroniosIntermediarios,
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

    var _lastDirection: Direction?
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

    func entrada(slots: [Slot]) -> Agent.Movement? {

        let input = slots.map({Double($0.type.index)})

        let rede1 = neuroniosIntermediarios.map { (neuronio) -> Double in
            return neuronio.calculaPesos(parametros: input)
        }

        let movimentos = neuroniosMovimento.map { (neuronio) -> Double in
            return neuronio.calculaPesos(parametros: rede1)
        }

        let direcoes = neuroniosDirecao.map { (neuronio) -> Double in
            return neuronio.calculaPesos(parametros: rede1)
        }

        let movimentoKey = movimentos.enumerated().max(by: {$0.element < $1.element})
        let direcaoKey = direcoes
            .enumerated()
            .filter({$0.offset != getToogleDirection()?.rawValue})
            .max(by: {$0.element < $1.element})

        let movimento = Acao(rawValue: movimentoKey!.offset)


        var direcao: Direction?
        direcao = Direction(rawValue: direcaoKey!.offset)
        _lastDirection = direcao

        return (movimento!, direcao!)

    }
}
