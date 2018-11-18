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
    
    func processRegion(_ regionList: Map.RegionList) {
        regionList.forEach { (slot) in
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
    
    func processRegionLookingBags(dataNode: [DataNode], _ routeData: Map.RouteData?) {
        
        if routeData?.route.last?.type == .saco {
            switchEvent(.goToRoute(routeData!))
            return
        }
        
        if let slot = dataNode.first(where: {$0.slot.type == .saco})?.slot {
            switchEvent(.goToSlot(slot, true))
            return
        }
        
        if routeData != nil {
            switchEvent(.goToRoute(routeData!))
            return
        }
        
        switchEvent(.randomBags(dataNode))
    }
    
    func processRegionLookingCheastAndDoor(dataNode: [DataNode], _ routeData: Map.RouteData?) {
        
        if door != nil, cheasts.count == map.mapSettings.cheastNumbers {
            switchEvent(.distributedBags)
            return
        }
        
        if routeData != nil {
            self.switchEvent(.goToRoute(routeData!))
            return
        }
        
        self.switchEvent(.randomBags(dataNode))
    }
}
