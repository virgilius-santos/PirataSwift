//
//  Delegate.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

protocol AgentDelegate {
    func update(coins: Int, general: Int)
    func growUp(_ slot: Slot)
    func bauLocalizado(qtd: Int)
    func portaLocalizada(_ status: Bool)
    func divisaoDeSacolas(_ div: String)
    func getBag(slot: Slot, speed: Double) -> Bag
    func getSlot(fromIndex index: Index) -> Slot
    func next()
}

extension Agent {

    func next() {
        self.delegate?.next()
    }
    
    func updateValues() {
        let coins = self.totalCoins
        let general = self.totalPoints
        self.delegate?.update(coins: coins, general: general)
    }
    
    func bauLocalizado() {
        self.delegate?.bauLocalizado(qtd: self.cheasts.count)
    }
    
    func portaLocalizada() {
        self.delegate?.portaLocalizada(true)
    }
    
    func divisaoDeSacolas(_ div: String) {
        self.delegate?.divisaoDeSacolas(div)
    }

    func growUp(_ slot: Slot) {
        self.delegate?.growUp(slot)
    }

    func coletarBag(_ slot: Slot) -> Bag {
        return delegate!.getBag(slot: slot, speed: self.speed)
    }

    func mapSlot() -> Slot {
        return delegate!.getSlot(fromIndex: location.index)
    }
}
