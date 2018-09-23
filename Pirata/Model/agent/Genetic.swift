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
        
        let qtdPopulacao = elite + baus * 5000
        
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
            
            self.generation = 0
            
            self.popular()
            
            self.calcularAptidoes()
            
            var index: Int? = nil
            repeat {
                self.generation += 1
                
                self.elitizar()
                
                self.gerar()
                
                self.mutar()
                
                self.calcularAptidoes()
                
                index = self.checkElite()
                
            } while (index == nil && self.generation < 20 )
            
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
        var pais: [Int] = []
        for i in 0 ..< baus {
            pais.append(randomNumber(aptidoes.count/baus) + i*baus)
        }
        let melhor = pais
            .map({(index:$0,value:aptidoes[$0])})
            .sorted(by: {$0.value < $1.value})
            .first!
            .index

        return melhor
    }
    
    private func gerar() {
        
        var idxBauInicial = 0
        
        // funcao similiar a for (int i=0, i<16; i+=4)
        // para avançar de quatro em quatro nas linhas da populacao
        // a partir da linha 1, ex. 1,5,9
        stride(from: 1, to: populacao.count, by: baus).forEach { linha in
            
            // array com index aleatorios dos projenitores
            // de acordo com o numero de baus
            var idxProjenitores: [Int] = [Int]()
            for _ in 0 ..< baus {
                idxProjenitores.append(tornetizar())
            }
            
            // funcao similiar a for (int i=0, i<16; i+=4)
            // para avançar de quatro em quatro nas linhas da populacao
            // a partir da linha 1, ex. 1,5,9
            stride(from: 0, to: populacao[linha].count, by: baus).forEach { idxSacolas in
                
                var idxProj = idxBauInicial
                for idxSac in idxSacolas ..< (idxSacolas + baus) {
                    for linUnitaria in linha ..< (linha + baus) {
                        popIntermediaria[linUnitaria][idxSac]
                            = populacao[idxProjenitores[idxProj]][idxSac]
                        idxProj = (idxProj+1) % baus
                    }
                }
                
                idxBauInicial = (idxBauInicial+1) % baus
            }
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
            let mean: Float = Float(arrayBaus.reduce(0, +)) / Float(arrayBaus.count)
            let sd: Float = (arrayBaus.reduce(0.0, {$0 + sqrt(pow((Float($1)-mean),2)/Float(arrayBaus.count))}))
            aptidoes[i] = sd
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
