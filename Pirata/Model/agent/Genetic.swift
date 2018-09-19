//
//  Genetic.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Genetic {
    private var carga: [Bag]
    private var total: Int { return carga.reduce(0, {$0+$1.valor})}
    private var cheasts: Int
    
    private var populate: [[Int]]
    private var intermediate: [[Int]]
    private var aptidoes: [Float]
    private var aptIntermediate: [Float]
    
    private var generation: Int
    private var elite = 10
    
    init(carga: [Bag], cheasts: Int) {
        self.carga = carga
        self.cheasts = cheasts
        
        let line = [Int](repeating: 0, count: carga.count)
        let qtd = cheasts*10 + elite
        
        self.populate = [[Int]](repeating: line, count: qtd)
        self.intermediate = [[Int]](repeating: line, count: qtd)
        self.aptidoes = [Float](repeating: 0.0, count: qtd)
        self.aptIntermediate = [Float](repeating: 0.0, count: qtd)
        
        self.generation = 0
    }
    
    func start(completion:@escaping([[Bag]])->()) {
        DispatchQueue(label: "genetic").async {
            
            self.popular()
            
            self.aptidar()
            self.generation = 0
            
            var index: Int? = nil
            repeat {
                self.generation += 1
                
                let limit = self.elitizar(set: self.elite)
                
                self.gerar(start: limit)
                
                self.mutar()
                
                self.aptidar()
                
                index = self.checkElite()
                
            } while (index == nil && self.generation < 30 )
            
            if index == nil, self.rePopulateIfNeed() {
                self.start(completion: completion)
                return
            }
            
            let values = self.decodificar(index: index ?? 0)
            
            completion(values)
        }
    }
    
    func checkElite() -> Int? {
        return aptidoes.index(where: {$0 == 0})
    }
    
    var limit = 10; var count = 5
    private func rePopulateIfNeed() -> Bool {
        if count == limit { return false }
        count += 1
        popular(start: 5)
        return true
    }
    
    private func decodificar(index: Int) -> [[Bag]] {
        var decode: [[Bag]] = [[Bag]](repeating: [], count: cheasts)
        
        let values = populate[index]
        for i in 0 ..< values.count {
            decode[values[i]].append(carga[i])
        }
        return decode
    }
    
    private func mutar() {
        let fator = Int(arc4random_uniform(100))
        let member = Int(arc4random_uniform(UInt32(populate.count)))
        let gene = Int(arc4random_uniform(UInt32(populate[member].count)))
        if (fator < 95 ) {
            var value = populate[member][gene]
            while value == populate[member][gene] {
                value = Int(arc4random_uniform(3))
            }
            populate[member][gene] = value
        }
    }
    
    private func gerar(start: Int) {
        
        let f: [Int] = [Int](repeating: tornetizar(), count: cheasts)
        var firstIndex = -1
        
        for linha in start ..< intermediate.count {
            
            firstIndex = (firstIndex + 1) % cheasts
            
            stride(from: 0, to: intermediate[linha].count, by: cheasts).forEach { i in
                
                for j in i ..< i+cheasts {
                    let index = f[(firstIndex + j) % cheasts]
                    intermediate[linha][i ..< i+cheasts] = populate[index][i ..< i+cheasts]
                }
            }
        }
        
        populate = intermediate
    }
    
    private func tornetizar() -> Int {
        let primeiro = Int(arc4random_uniform(UInt32(aptidoes.count)))
        let segundo = Int(arc4random_uniform(UInt32(aptidoes.count)))
        let v1 = aptidoes[primeiro]
        let v2 = aptidoes[segundo]
        return (v1 < v2) ? primeiro : segundo
    }
    
    private func elitizar(set: Int) -> Int {
        var sorted = Set(aptidoes).map({$0}).sorted()
        let limit = sorted.count < set ? sorted.count : set
        for i in 0 ..< limit {
            let sd = sorted[i]
            let index = aptidoes.index(of: sd)!
            intermediate[i] = populate[index]
            aptIntermediate[i] = aptidoes[index]
        }
        return limit
    }
    
    private func aptidar() {
        for i in 0 ..< populate.count {
            var v: [Int] = [Int](repeating: 0, count: cheasts)
            for j in 0 ..< populate[i].count {
                for k in 0 ..< cheasts {
                    if populate[i][j] == k {
                        v[k] += carga[j].valor
                    }
                }
            }
            
            let mean: Float = Float(v.reduce(0, +)) / Float(v.count)
            let sd: Float = (v.reduce(0.0, {$0 + sqrt(pow((Float($1)-mean),2)/Float(v.count))}))
            aptidoes[i] = sd
        }
    }
    
    private func popular(start: Int = 0) {
        for i in start ..< populate.count {
            for j in 0 ..< populate[i].count {
                populate[i][j] = Int(arc4random_uniform(UInt32(cheasts)))
            }
        }
    }
    
}
