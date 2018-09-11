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
    
    private var populate: [[Int]]
    private var intermediate: [[Int]]
    
    private var generation: Int
    
    init(carga: [Bag]) {
        self.carga = carga
        
        let line = [Int](repeating: -2, count: carga.count+1)
        let qtd = 4*60 + 1
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
    
    var limit = 200
    var count = 0
    private func rePopulateIfNeed() -> Bool {
        if populate[0][populate[0].count-1] == 0 {  return false }
        if count == limit { return false }
        count += 1
        popular(start: count%10)
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
        var v1: [Bag] = []
        var v2: [Bag] = []
        var v3: [Bag] = []
        var v4: [Bag] = []
        let values = populate[0]
        for i in 0 ..< values.count-1 {
            if values[i] == 0 {
                v1.append(carga[i])
            } else if values[i] == 1 {
                v2.append(carga[i])
            } else if values[i] == 2 {
                v3.append(carga[i])
            } else if values[i] == 3 {
                v4.append(carga[i])
            }
        }
//        print("generation:\(generation)\ncount:\(count)")
//        print(" - \(v1) - \(v2) - \(v3) - \(v4) - \(values[values.count-1])\n")
        return [v1,v2,v3,v4]
    }
    
    private func gerar() {
        var linha = 0
        let qtd = (populate.count / 4)
        for i in 0 ..< qtd {
            let last = populate[i].count-1
            
            let f = [tornetizar(),tornetizar(),tornetizar(),tornetizar()]
            
            linha += 1
            for j in 0 ..< last {
                let f0 = f[j%4]
                let f1 = f[(j+1)%4]
                let f2 = f[(j+2)%4]
                let f3 = f[(j+3)%4]
                intermediate[linha+0][j] = populate[f0][j]
                intermediate[linha+1][j] = populate[f1][j]
                intermediate[linha+2][j] = populate[f2][j]
                intermediate[linha+3][j] = populate[f3][j]
            }
            
            linha += 3
            
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
            var v1: Int = 0
            var v2: Int = 0
            var v3: Int = 0
            var v4: Int = 0
            populate[i][last] = 0
            for j in 0 ..< last {
                if populate[i][j] == 0 {
                    v1 += carga[j].valor
                } else if populate[i][j] == 1 {
                    v2 += carga[j].valor
                } else if populate[i][j] == 2 {
                    v3 += carga[j].valor
                } else if populate[i][j] == 3 {
                    v4 += carga[j].valor
                }
            }
            populate[i][last] += abs(v1-(total/4))
            populate[i][last] += abs(v2-(total/4))
            populate[i][last] += abs(v3-(total/4))
            populate[i][last] += abs(v4-(total/4))
        }
    }
    
    private func popular(start: Int = 0) {
        for i in start ..< populate.count {
            let last = populate[i].count-1
            for j in 0 ..< last {
                populate[i][j] = Int(arc4random_uniform(4))
            }
            populate[i][last] = 0
        }
    }
    
}
