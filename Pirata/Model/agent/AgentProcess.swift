//
//  AgentProcess.swift
//  Pirata
//
//  Created by Virgilius Santos on 11/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Agent {
    
    func processMove(to: Slot, next: Int, route: [Slot]) {
        self.location = to
        if to.type == .saco {
            self.switchEvent(.colectBag)
        } else if next+1 < route.count {
            switchEvent(.traveling((route, next)))
        } else if isCompleted {
            switchEvent(.distributedBags)
        } else {
            switchEvent(.start)
        }
    }
    
    func processRegion(_ region: [[Slot]]) {
        region.flatMap({$0}).forEach { (slot) in
            if slot.type == .bau, !self.cheasts.contains(where: {$0.slot == slot}) {
                let cheast = Cheast(slot)
                self.cheasts.append(cheast)
                self.bauLocalizado()
            } else if slot.type == .porta {
                self.door = slot
                self.portaLocalizada()
            }
        }
    }
    
    func processRegionLookingBags(dataNode: [DataNode], _ data: ([Slot], Int)?) {
        
        if let (route, index) = data, route.last?.type == .saco {
            switchEvent(.goToRoute((route, index)))
            return
        }
        
        if let slot = dataNode.first(where: {$0.slot.type == .saco})?.slot {
            switchEvent(.goToSlot(slot, true))
            return
        }
        
        if let (route, index) = data {
            switchEvent(.goToRoute((route, index)))
            return
        }
        
        switchEvent(.randomBags(dataNode))
    }
    
    func processRegionLookingCheastAndDoor(dataNode: [DataNode], _ data: ([Slot], Int)?) {
        
        if door != nil, cheasts.count == map.mapSettings.cheastNumbers {
            switchEvent(.distributedBags)
            return
        }
        
        if let (route, index) = data {
            self.switchEvent(.goToRoute((route, index)))
            return
        }
        
        self.switchEvent(.randomBags(dataNode))
    }
}
