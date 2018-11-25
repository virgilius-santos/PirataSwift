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

    private var weights: [NeuralNet.Weights] = []
    private var intermediateWeights: [NeuralNet.Weights] = []
    var aptitudes: [Double] = []

    var genesis = -1

    var weightSelected = -1

    var lastptitude: Double = -2

    var setAptitude: Double = -1

    /// inicia os array com a qtd de pessos passada
    /// para cada item da matrix gera um peso
    /// com uma distribuição aleatória
    func popular(weight: Int) {
        weightSelected = -1
        let qtd: Int = 10*50

        weights = [NeuralNet.Weights](
            repeating: NeuralNet.Weights(repeating: 0, count: weight),
            count: qtd
        )

        intermediateWeights = [NeuralNet.Weights](
            repeating: NeuralNet.Weights(repeating: 0, count: weight),
            count: qtd
        )

        aptitudes
            = [Double](repeating: -1000, count: qtd)

        for i in 0 ..< qtd {
            for j in 0 ..< weight {
                weights[i][j] = (Double.randomDouble)
            }
        }
    }

    func getNextWeights() -> NeuralNet.Weights {
        genesis += 1
        weightSelected += 1
        canShow = (weightSelected == 0 && setAptitude != lastptitude)
        if weightSelected == 0 {
            lastptitude = setAptitude
        }
        return weights[weightSelected]

    }

    func setarAptidoes(apt: Double) {
        aptitudes[weightSelected] = apt
        if weightSelected+1 == aptitudes.count {
            processar()
        }
    }

    private func processar() {
        weightSelected = -1
        elitizar()
        gerar()
        mutar()
    }

    /// com probabilidade de 80% ele muta um gene de um elemento da populacao
    private func mutar() {
        for _ in 0...weights.count/2 {
            let coeficiente = Int.randomNumber(100)
            if (coeficiente < 80 ) {
                let member = max(Int.randomNumber(weights.count),1)
                for i in 0 ..< weights[member].count {
                    var value: Double = 0
                    repeat {
                        value = Double.randomDouble
                    } while value == weights[member][i]
                    weights[member][i] = value
                }
            }
        }
    }


    /// gera dois possiveis pais
    /// retorna o index do pai com o menor valor
    private func tornetizar() -> Int {

        let line1 = Int.randomNumber(weights.count)
        var line2 = 0
        repeat {
            line2 = Int.randomNumber(weights.count)
        } while (line2 == line1)

        let apt1 = aptitudes[line1]
        let apt2 = aptitudes[line2]

        return (apt1 < apt2) ? line2 : line1
    }

    private func gerar() {

        // funcao similiar a for (int i=0, i<16; i+=4)
        // para avançar de quatro em quatro nas linhas da populacao
        // a partir da linha 1, ex. 1,5,9
        let total = weights.count
        for line in 1..<total {

            let mother = tornetizar()
            var father = tornetizar()
            while (father == mother) {
                father = tornetizar()
            }

            let final = weights[line].count
            for index in 0..<final {
                let vFather = weights[father][index]
                let vMother = weights[mother][index]
                intermediateWeights[line][index] = (vFather + vMother) / 2
            }
        }

        weights = intermediateWeights
        aptitudes = [Double](repeating: -1000, count: weights.count)
    }

    private func elitizar() {

        // set (chave, valor) ordenada para pegar o index do menor valor
        let sortedSet = aptitudes
            .enumerated()
            .sorted(by: { (set1, set2) -> Bool in
                return set1.element > set2.element
            })

        /// seta o menor valor ao indice zero da populacao intermediarias
        if let (index, value) = sortedSet.first {
            intermediateWeights[0] = weights[index]
            setAptitude = value
        }
    }
}
