//
//  Util.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Agent {
    
    
    func processRegion(_ region: [[Slot]]) {
        region.flatMap({$0}).forEach { (slot) in
            if slot.type == .bau, !self.cheasts.contains(where: {$0.slot == slot}) {
                let cheast = Cheast(slot)
                self.cheasts.append(cheast)
            } else if slot.type == .porta {
                self.door = slot
            }
        }
    }
    
    func colectBag() {
        map.cleanImage(slot: self.location) { bag in
            self.bags.append(bag!)
            self.checkIfisCompleted()
        }
    }
    
    func checkIfisCompleted() {
        if map.bags.totalSet * 10 == totalCoins {
            if self.isCompleted != true {
                self.isCompleted = true
            }
            self.switchEvent(.completed)
        } else {
            self.switchEvent(.start)
        }
    }
}
