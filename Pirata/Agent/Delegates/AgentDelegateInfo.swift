//
//  Delegate.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

protocol AgentDelegateInfo: class {
    func update(coins: Int, general: Int, genesis: Int)
    func locateCheast(qtd: Int)
    func locateDoor(_ status: Bool)
    func splitBags(_ div: String)
    func next()
}

extension Agent {

    func next() {
        self.delegate?.next()
    }
    
    func updateValues() {
        let coins = agentData.totalCoins
        let general = agentData.totalPoints
        let genesis = neuralNet.genetic.genesis
        self.delegate?.update(coins: coins, general: general, genesis: genesis)
    }
    
    func locateCheast() {
        self.delegate?.locateCheast(qtd: agentData.cheasts.count)
    }
    
    func locateDoor() {
        self.delegate?.locateDoor(true)
    }
    
    func splitBags(_ div: String) {
        self.delegate?.splitBags(div)
    }

}
