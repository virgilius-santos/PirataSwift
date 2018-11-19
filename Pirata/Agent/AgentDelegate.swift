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
    func getBag(slot: Slot, speed: Double, completion: @escaping(Bag)->())
    func next()
}

extension Agent {

    func next() {
        DispatchQueue.main.async {
            self.delegate?.next()
        }
    }
    
    func updateValues() {
        DispatchQueue.main.async {
            let coins = self.totalCoins
            let general = self.totalPoints
            self.delegate?.update(coins: coins, general: general)
        }
    }
    
    func growUp(_ slot: Slot) {
        DispatchQueue.main.async {
            self.delegate?.growUp(slot)
        }
    }
    
    
    func bauLocalizado() {
        DispatchQueue.main.async {
            self.delegate?.bauLocalizado(qtd: self.cheasts.count)
        }
    }
    
    func portaLocalizada() {
        DispatchQueue.main.async {
            self.delegate?.portaLocalizada(true)
        }
    }
    
    func divisaoDeSacolas(_ div: String) {
        DispatchQueue.main.async {
            self.delegate?.divisaoDeSacolas(div)
        }
    }

    func coletarBag(_ slot: Slot, completion: @escaping(Bag)->()) {
        DispatchQueue.main.async {
            self.delegate?.getBag(slot: slot, speed: self.speed, completion: completion)
        }
    }
}
