//
//  NeuralGenetic.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class NeuralGenetic {

    var canShow = false

    private var populacao: [[Double]] = []
    private var popIntermediaria: [[Double]] = []
    var aptidoes: [Double] = []

    var populacaoSelected = -1

    var geracao = -1

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


    var last: Double = -2
    func getPesosFromNextPopulation() -> [Double] {
        geracao += 1
        populacaoSelected += 1
        canShow = (populacaoSelected == 0 && setAptidao != last)
        if populacaoSelected == 0 {
            last = setAptidao
        }
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
        for _ in 0...populacao.count/2 {
            let fator = Int.randomNumber(100)
            if (fator < 80 ) {
                let member = max(Int.randomNumber(populacao.count),1)
                for i in 0 ..< populacao[member].count {
                    var value: Double = 0
                    repeat {
                        value = Double.randomDouble
                    } while value == populacao[member][i]
                    populacao[member][i] = value
                }
            }
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

        return (apt1 < apt2) ? linha2 : linha1
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
        aptidoes = [Double](repeating: -1000, count: populacao.count)
    }

    var setAptidao: Double = -1
    private func elitizar() {

        // set (chave, valor) ordenada para pegar o index do menor valor
        let setSorted = aptidoes
            .enumerated()
            .sorted(by: { (set1, set2) -> Bool in
                return set1.element > set2.element
            })

        /// seta o menor valor ao indice zero da populacao intermediarias
        if let (index, value) = setSorted.first {
            popIntermediaria[0] = populacao[index]
            setAptidao = value
        }
    }
}
