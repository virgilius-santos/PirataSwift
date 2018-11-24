//
//  NeuralGenetic.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class NeuralGenetic {

    private var populacao: [[Double]] = []
    private var popIntermediaria: [[Double]] = []
    private var aptidoes: [Double] = []

    var populacaoSelected = -1

    /// inicia os array com a qtd de pessos passada
    /// para cada item da matrix gera um peso
    /// com uma distribuição aleatória
    func popular(pesos: Int) {
        populacaoSelected = -1
        let qtd: Int = 10*50
        populacao
            = [[Double]](repeating: [Double](repeating: 0, count: pesos), count: qtd)
        popIntermediaria
            = [[Double]](repeating: [Double](repeating: 0, count: pesos), count: qtd)
        aptidoes
            = [Double](repeating: -1000, count: qtd)

        for i in 0 ..< qtd {
            for j in 0 ..< pesos {
                populacao[i][j] = (Double.randomDouble)
            }
        }
    }

    func getPesosFromNextPopulation() -> [Double] {

        populacaoSelected += 1
        return populacao[populacaoSelected]

    }

    func setarAptidoes(apt: Double) {
        aptidoes[populacaoSelected] = apt
        if populacaoSelected+1 == aptidoes.count {
            processar()
        }
    }

    private func processar() {
        populacaoSelected = -1
        elitizar()
        gerar()
        mutar()
    }

    /// com probabilidade de 50% ele muta um gene de um elemento da populacao
    private func mutar() {
        let fator = Int.randomNumber(100)
        let member = Int.randomNumber(populacao.count)
        let gene = Int.randomNumber(populacao[member].count)
        if (fator < 50 ) {
            var value = populacao[member][gene]
            while value == populacao[member][gene] {
                value = Double.randomDouble
            }
            populacao[member][gene] = value
        }
    }

    /// gera dois possiveis pais
    /// retorna o index do pai com o menor valor
    private func tornetizar() -> Int {

        let linha1 = Int.randomNumber(populacao.count)
        var linha2 = 0
        repeat {
            linha2 = Int.randomNumber(populacao.count)
        } while (linha2 == linha1)

        let apt1 = aptidoes[linha1]
        let apt2 = aptidoes[linha2]

        return (apt1 < apt2) ? linha1 : linha2
    }

    private func gerar() {

        // funcao similiar a for (int i=0, i<16; i+=4)
        // para avançar de quatro em quatro nas linhas da populacao
        // a partir da linha 1, ex. 1,5,9
        let total = populacao.count
        for linha in 1..<total {

            let mae = tornetizar()
            var pai = tornetizar()
            while (pai == mae) {
                pai = tornetizar()
            }

            let final = populacao[linha].count
            for index in 0..<final {
                let vPai = populacao[pai][index]
                let vMae = populacao[mae][index]
                popIntermediaria[linha][index] = (vPai + vMae) / 2
            }
        }

        populacao = popIntermediaria
    }

    private func elitizar() {

        // set (chave, valor) ordenada para pegar o index do menor valor
        let setSorted = aptidoes
            .enumerated()
            .sorted(by: { (set1, set2) -> Bool in
                return set1.element < set2.element
            })

        /// seta o menor valor ao indice zero da populacao intermediarias
        if let (index, _) = setSorted.first {
            popIntermediaria[0] = populacao[index]
        }
    }
}
