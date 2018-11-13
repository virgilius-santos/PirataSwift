//
//  Genetic.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Genetic {
    private var sacolas: [Bag]
    private var total: Int { return sacolas.reduce(0, {$0+$1.valor})}
    private var baus: Int
    
    private var populacao: [[Int]]
    private var popIntermediaria: [[Int]]
    private var aptidoes: [Float]
    
    private var generation: Int
    private var elite = 1
    
    init(sacolas: [Bag], baus: Int) {
        self.sacolas = sacolas
        self.baus = baus
        
        let qtdPopulacao = elite + baus * 500
        
        self.populacao = [[Int]] (
            repeating: [Int](repeating: 0, count: sacolas.count),
            count: qtdPopulacao
        )
        self.popIntermediaria =  [[Int]] (
            repeating: [Int](repeating: 0, count: sacolas.count),
            count: qtdPopulacao
        )
        
        self.aptidoes = [Float](
            repeating: 0.0,
            count: qtdPopulacao
        )
        
        self.generation = 0
    }
    
    func start(completion:@escaping([[Bag]])->()) {
        DispatchQueue(label: "genetic").async {
            var repeatTimes = 100
            var index: Int? = nil
            repeat {
                self.generation = 0
                
                self.popular()
                
                self.calcularAptidoes()
                
                repeat {
                    self.generation += 1
                    
                    self.elitizar()
                    
                    self.gerar()
                    
                    self.mutar()
                    
                    self.calcularAptidoes()
                    
                    index = self.checkElite()
                    
                } while (index == nil && self.generation < 40 )
                
                repeatTimes -= 1
            } while (index == nil && repeatTimes > 0 )
            
            let values = self.decodificar(index: index ?? 0)
            
            completion(values)
        }
    }
    
    func checkElite() -> Int? {
        return aptidoes.index(where: {$0 == 0})
    }
    
    private func decodificar(index: Int) -> [[Bag]] {
        var decode: [[Bag]] = [[Bag]](repeating: [], count: baus)
        
        let values = populacao[index]
        for i in 0 ..< values.count {
            decode[values[i]].append(sacolas[i])
        }
        return decode
    }
    
    /// com probabilidade de 50% ele muta um gene de um elemento da populacao
    private func mutar() {
        let fator = randomNumber(100)
        let member = randomNumber(populacao.count)
        let gene = randomNumber(populacao[member].count)
        if (fator < 50 ) {
            var value = populacao[member][gene]
            while value == populacao[member][gene] {
                value = randomNumber(baus)
            }
            populacao[member][gene] = value
        }
    }
    
    /// gera um array de possiveis pais
    /// retorna o index do pai com o menor valor
    private func tornetizar() -> Int {

        let linha1 = randomNumber(populacao.count)
        var linha2 = 0
        repeat {
            linha2 = randomNumber(populacao.count)
        } while (linha2 == linha1)
        
        let apt1 = aptidoes[linha1]
        let apt2 = aptidoes[linha2]
        
        return (apt1 < apt2) ? linha1 : linha2
    }
    
    private func gerar() {
        
        // funcao similiar a for (int i=0, i<16; i+=4)
        // para avançar de quatro em quatro nas linhas da populacao
        // a partir da linha 1, ex. 1,5,9
        stride(from: 1, to: populacao.count, by: 2).forEach { linha in
            
            var mae = 0
            
            let pai = tornetizar()
            repeat {
                mae = tornetizar()
            } while (pai == mae)
            
            // funcao similiar a for (int i=0, i<16; i+=4)
            // para avançar de quatro em quatro nas linhas da populacao
            // a partir da linha 1, ex. 1,5,9
            let final = populacao[linha].count
            let step = final/2
            
            popIntermediaria[linha][0..<step] = populacao[pai][0..<step]
            popIntermediaria[linha][step..<final] = populacao[mae][step..<final]
            
            popIntermediaria[linha+1][0..<step] = populacao[mae][0..<step]
            popIntermediaria[linha+1][step..<final] = populacao[pai][step..<final]
            
        }
        
        populacao = popIntermediaria
    }
    
    private func elitizar(){
        
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
    
    private func calcularAptidoes() {
        
        for i in 0 ..< populacao.count {
            
            /// array com o numero de baus iniciado em zero
            var arrayBaus: [Int] = [Int](repeating: 0, count: self.baus)
            
            /// as sacolas sao somadas ao bau correspondente
            for j in 0 ..< populacao[i].count {
                let indiceBau = populacao[i][j]
                arrayBaus[indiceBau] += sacolas[j].valor
            }
            
            /// calcula o desvio padrao usando os valores dos baus
//            let mean: Float = Float(arrayBaus.reduce(0, +)) / Float(arrayBaus.count)
//            let sd: Float = (arrayBaus.reduce(0.0, {$0 + sqrt(pow((Float($1)-mean),2)/Float(arrayBaus.count))}))
//            aptidoes[i] = sd
            for j in 0 ..< arrayBaus.count {
                arrayBaus[j] = abs((total/baus) - arrayBaus[j])
            }
            
            let mean: Float = Float(arrayBaus.reduce(0, +)) / Float(arrayBaus.count)
            aptidoes[i] = mean
        }
    }
    
    /// para cada item da matrix gera um bau
    /// com uma distribuição aleatória
    private func popular(start: Int = 0) {
        for i in start ..< populacao.count {
            for j in 0 ..< populacao[i].count {
                populacao[i][j] = randomNumber(baus)
            }
        }
    }
    
}
