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
    
    private var generation: Int
    
    init(carga: [Bag], cheasts: Int) {
        self.carga = carga
        self.cheasts = cheasts
        
        let line = [Int](repeating: -2, count: carga.count+1)
        let qtd = cheasts*80 + 1
        self.populate = [[Int]](repeating: line, count: qtd)
        self.intermediate = [[Int]](repeating: line, count: qtd)
        self.generation = 0
    }
    
    func start(completion:@escaping([[Bag]])->()) {
        DispatchQueue(label: "genetic").async {
            self.popular()
            
            repeat {
                self.processar()
            } while self.rePopulateIfNeed()
            
            let values = self.decodificar()
            completion(values)
        }
    }
    
    func processar() {
        for i in 0 ... 20 {
            self.generation = i
            
            aptidar()
            
            elitizar()
            
            gerar()
            
            mutar()
            
        }
    }
    
    var limit = 50
    var count = 5
    private func rePopulateIfNeed() -> Bool {
        if populate[0][populate[0].count-1] == 0 {  return false }
        if count == limit { return false }
        count += 1
        popular(start: count%20)
        return true
    }
    
    private func mutar() {
        let fator = Int(arc4random_uniform(100))
        let member = Int(arc4random_uniform(UInt32(populate.count)))
        let gene = Int(arc4random_uniform(UInt32(populate[member].count)))
        if (fator < 5 ) {
            var value = populate[member][gene]
            while value == populate[member][gene] {
                value = Int(arc4random_uniform(3))
            }
            populate[member][gene] = value
        }
    }
    
    private func decodificar() -> [[Bag]] {
        var decode: [[Bag]] = [[Bag]](repeating: [], count: cheasts)
        let values = populate[0]
        for i in 0 ..< values.count-1 {
            decode[values[i]].append(carga[i])
        }
        return decode
    }
    
    private func gerar() {
        var linha = 0
        let qtd = (populate.count / cheasts)
        for i in 0 ..< qtd {
            let last = populate[i].count-1
            
            let f: [Int] = [Int](repeating: tornetizar(), count: cheasts)
            
            linha += 1
            for j in 0 ..< last {
                for k in 0 ..< cheasts {
                    let f = f[(j+k)%cheasts]
                    intermediate[linha+k][j] = populate[f][j]
                }
            }

            linha += (cheasts-1)
            
        }
        
        populate = intermediate
    }
    
    private func tornetizar() -> Int {
        let primeiro = Int(arc4random_uniform(UInt32(populate.count / 2)))
        let segundo = Int(arc4random_uniform(UInt32(populate.count / 2))) + populate.count / 2 - 1
        let v1 = populate[primeiro][populate[primeiro].count-1]
        let v2 = populate[segundo][populate[segundo].count-1]
        return (v1 < v2) ? primeiro : segundo
    }
    
    private func elitizar() {
        var indexMenor = 0
        for i in 0 ..< populate.count {
            let last = populate[i].count-1
            if (populate[i][last] < populate[indexMenor][last]) {
                indexMenor = i;
            }
        }
        intermediate[0] = populate[indexMenor]
    }
    
    private func aptidar() {
        for i in 0 ..< populate.count {
            let last = populate[i].count-1
            var v: [Int] = [Int](repeating: 0, count: cheasts)
            populate[i][last] = 0
            for j in 0 ..< last {
                for k in 0 ..< cheasts {
                    if populate[i][j] == k {
                        v[k] += carga[j].valor
                    }
                }
            }
            for k in 0 ..< cheasts {
                populate[i][last] += abs(v[k]-(total/cheasts))
            }
        }
    }
    
    private func popular(start: Int = 0) {
        for i in start ..< populate.count {
            let last = populate[i].count-1
            for j in 0 ..< last {
                populate[i][j] = Int(arc4random_uniform(UInt32(cheasts)))
            }
            populate[i][last] = 0
        }
    }
    
}
