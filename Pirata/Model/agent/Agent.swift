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
        self.location = mock ? Slot(index: Index(col: 4, row: 9)) : location
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
                
            case .goToRoute(let route, let index):
                
                if route[index + 1].type == .buraco {
                    self.holeAction(route: route, index: index)
                } else {
                    self.move(route: route, index: index)
                }
                
            case .colectBag:
                self.colectBag()
                
            case .traveling(let data):
                self.analiseRegion(data)
                
            case .randomBags(let dataNode):
                self.randomSlot(dataNode)
                
            case .completed:
                self.completedAction()
                
            case .distributedBags:
                self.distributedBagsInCheasts()
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
    
    func getRoute(toBag bag: Slot, excludeRole: Bool = true) {
        map.calcRoute(from: location, to: bag, excludeRole: excludeRole) { (route) in
            if route.count > 1 {
                self.switchEvent(.goToRoute((route,0)))
            } else {
                self.switchEvent(.start)
            }
        }
    }
    
    func move(route: [Slot], index: Int = 0) {
        let next = index + 1
        let to = route[next]
        
        self.moveView(to: to) {
            self.processMove(to: to, next: next, route: route)
        }
    }
    
    func holeAction(route: [Slot], index: Int) {
        if route.count <= index + 2 {
            print("\(#function) -errorHoleDetected\n \n")
            switchEvent(.start)
            return
        }
        
        var last = index + 2
        let from = route[index]
        var to = route[last]
        
        if to.type == .buraco {
            while (to.type == .buraco) {
                last += 1
                if last == route.count {
                    switchEvent(.start)
                    return
                }
                to = route[last]
            }
            switchEvent(.goToSlot(to, false))//getRoute(toBag: to, excludeRole: false)
            return
        }
        
        if from.index.col != to.index.col, from.index.row != to.index.row {
            switchEvent(.goToSlot(to, false))//getRoute(toBag: to, excludeRole: false)
            return
        }
        
        jumpView(to: to) {
            self.holeJumpeds += 1
            self.processMove(to: to, next: last, route: route)
        }
    }
    
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
    
}
