//
//  Agent.swift
//  Pirata
//
//  Created by Virgilius Santos on 08/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation



class Agent {
    
    var delegate: AgentDelegate?
    
    var map: Map
    var location: Slot
    
    var cheasts: [Cheast]
    var door: Slot?
    
    var holeJumpeds: Int = 0 {
        didSet {
            updateValues()
        }
    }
    
    var bags: [Bag] {
        didSet {
            updateValues()
        }
    }
    
    var distributedBags: [[Bag]]
    
    var totalCoins: Int {return self.bags.reduce(0, { $0 + $1.valor}) * 10}
    
    var isCompleted: Bool = false
    
    init(map: Map, startLocation location: Slot) {
        self.map = map
        self.location = Slot(index: Index(col: 1, row: 1))
        self.location.set(type: .pirate)
        self.bags = []
        self.cheasts = []
        self.distributedBags = []
    }
    
    func start() {
        print("Agent started\n")
        switchEvent(.start)
    }
    
    func switchEvent(_ event: EventType) {
        DispatchQueue(label: "agent").async {
            switch event {
            case .start:
                self.analiseRegion()
                
            case .goToSlot(let slot, let excludeRole):
                self.getRoute(toBag: slot, excludeRole: excludeRole)
                
            case .goToRoute(_, _):
                
//                if route[index + 1].type == .buraco {
//                    self.holeAction(route: route, index: index)
//                } else {
//                    self.move(route: route, index: index)
//                }
                    break
            case .colectBag:
                self.colectBag()
                
            case .traveling(let data):
                self.analiseRegion(data)
                
            case .randomBags(let dataNode):
                self.randomSlot(dataNode)
                
            case .completed:
                self.completedAction()
                
            case .distributedBags:
//                self.distributedBagsInCheasts()
                break
            }
        }
    }
    
    func analiseRegion(_ data: ([Slot], Int)? = nil) {
        map.getRegion(location) { (region) in
            
            self.processRegion(region)
            
            let dataNode: [DataNode] = region.flatMap({$0}).map { slot in
                let distance = self.map.calcDistance(from: self.location.index, to: slot.index)
                return DataNode(slot: slot, distance: distance)
            }.sorted(by: {$0.distance < $1.distance})
            
            if self.isCompleted {
                self.processRegionLookingCheastAndDoor(dataNode: dataNode, data)
                return
            }
            
            self.processRegionLookingBags(dataNode: dataNode, data)
        }
    }
    
}
