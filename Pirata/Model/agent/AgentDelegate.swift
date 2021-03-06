//
//  Delegate.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

protocol AgentDelegate {
    func move(to: Slot, completion: @escaping()->())
    func jump(to: Slot, completion: @escaping()->())
    func update(coins: Int, general: Int)
    func startflip()
    func stopflip(completion: @escaping()->())
    func goOut(direction: Direction, value: Float)
    func growUp(_ slot: Slot)
    func bauLocalizado(qtd: Int)
    func portaLocalizada()
    func divisaoDeSacolas(_ div: String)
}

extension Agent {
    func jumpView(to: Slot, completion: @escaping()->()) {
        DispatchQueue.main.async {
            self.delegate?.jump(to: to, completion: completion)
        }
    }
    
    func moveView(to: Slot, completion: @escaping()->()) {
        DispatchQueue.main.async {
            self.delegate?.move(to: to, completion: completion)
        }
    }
    
    func updateValues(_ solved: Bool = false) {
        DispatchQueue.main.async {
            let coins = self.totalCoins
            let general = coins + self.holeJumpeds * 30 + (solved ? 330 : 0)
            self.delegate?.update(coins: coins, general: general)
        }
    }
    
    func startflip() {
        DispatchQueue.main.async {
            self.delegate?.startflip()
        }
    }
    
    func stopflip(completion: @escaping()->()) {
        DispatchQueue.main.async {
            self.delegate?.stopflip(completion:completion)
        }
    }
    
    func goOut(direction: Direction, value: Float) {
        DispatchQueue.main.async {
            self.delegate?.goOut(direction: direction, value: value)
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
            self.delegate?.portaLocalizada()
        }
    }
    
    func divisaoDeSacolas(_ div: String) {
        DispatchQueue.main.async {
            self.delegate?.divisaoDeSacolas(div)
        }
    }
}
