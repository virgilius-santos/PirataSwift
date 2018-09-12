//
//  AgentProcess.swift
//  Pirata
//
//  Created by Virgilius Santos on 11/09/2018.
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
    
    func processRegionLookingBags(dataNode: [DataNode], _ data: ([Slot], Int)?) {
        let bagSlot = dataNode.first(where: {$0.slot.type == .saco})?.slot
        
        if let slot = bagSlot, let (route, index) = data {
            let d1 = map.calcDistance(from: location.index, to: slot.index)
            let d2 = map.calcDistance(from: location.index, to: route[index].index)
            if d1+1 < d2 || route[index].type != .saco {
                switchEvent(.goToSlot(slot, true))
            } else {
                switchEvent(.goToRoute((route, index)))
            }
            return
        }
        
        if let (route, index) = data {
            switchEvent(.goToRoute((route, index)))
            return
        }
        
        if let slot = bagSlot {
            switchEvent(.goToSlot(slot, true))
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
