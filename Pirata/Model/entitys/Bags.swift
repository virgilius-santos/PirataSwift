//
//  Bags.swift
//  Pirata
//
//  Created by Virgilius Santos on 08/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct Bags {
    var qtd: Int
    var defaultValue: Int = 200
    var limite: Int = 120
    var data: [Bag] = []
    var totalSet: Int { return defaultValue * qtd}
    
    init(_ qtd: Int) {
        self.qtd = qtd
        for _ in 0..<qtd {
            makePackage()
        }
    }
    
    mutating func makePackage() {
        var padrao = self.defaultValue
        for i in 1 ... 3 {
            let novoValor = Int(arc4random_uniform(UInt32(padrao/(4-i))))
            data.append(Bag(valor: novoValor))
            padrao -= novoValor
        }
        data.append(Bag(valor: padrao))
        
    }
}
