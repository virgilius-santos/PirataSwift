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
    
    func updateValues() {
        DispatchQueue.main.async {
            let coins = self.totalCoins
            let general = coins + self.holeJumpeds * 30
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
}
