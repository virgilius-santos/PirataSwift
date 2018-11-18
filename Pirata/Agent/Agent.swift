//
//  Agent.swift
//  Pirata
//
//  Created by Virgilius Santos on 08/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Agent {

    var defaultLocation: Slot

    var movementDelegate: AgentMovementDelegate?
    var delegate: AgentDelegate?

    var map: Map

    var location: Slot {
        get {
            return _location
        }
        set {
            if !stopped {
                _location = newValue
            } else {
                _location = defaultLocation
            }
        }
    }
    private var _location: Slot
    
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

    var stopped: Bool = false

    var isCompleted: Bool = false

    var speed: Double = 0.5
    
    init(map: Map, startLocation location: Slot) {
        self.map = map

        bags = []
        cheasts = []
        distributedBags = []

        _location = location
        _location.set(type: .pirate)
        defaultLocation = _location
    }

    func start() {
        print("Agent started\n")
        stopped = false
        DispatchQueue(label: "agent").async {
            self.switchEvent(.start)
        }
    }

    func stop() {
        print("Agent stoped\n")
        stopped = true
    }

    func reset() {
        bags.removeAll()
        cheasts.removeAll()
        door = nil
        distributedBags.removeAll()
        location = defaultLocation
    }
    
    func switchEvent(_ event: EventType) {
        if stopped {
            return
        }

        switch event {
        case .start:
            self.analiseRegion()

        case .lookingBags(let (dataNode, routeData)):
            self.processRegionLookingBags(dataNode: dataNode, routeData)
            break

        case .lookingCheastAndDoors(let (dataNode, routeData)):
            self.processRegionLookingCheastAndDoor(dataNode: dataNode, routeData)
            break

        case .goToSlot(let (slot, excludeRole)):
            self.getRoute(toBag: slot, excludeRole: excludeRole)

        case .goToRoute(let (route, index)):
            if route[index + 1].type == .buraco {
                self.holeAction(route: route, index: index)
            } else {
                self.move(route: route, index: index)
            }
                break

        case .colectBag:
            self.colectBag()

        case .traveling(let routeData):
            self.analiseRegion(routeData)

        case .randomBags(let dataNode):
            self.randomSlot(dataNode)

        case .completed:
//                self.completedAction()
            break

        case .distributedBags:
//                self.distributedBagsInCheasts()
            break
        }

    }
    
    func analiseRegion(_ routeData: Map.RouteData? = nil) {
        getRegion { (regionList) in
            
            self.processRegion(regionList)

            let dataNode: [DataNode] =
                regionList.getEmptyIndex()
                .map { slot in
                    let distance = slot.index.calcDistance(from: self.location.index)
                    return DataNode(slot: slot, distance: distance)
                }
                .sorted(by: {$0.distance < $1.distance})


            if self.isCompleted {
                self.switchEvent(.lookingCheastAndDoors(dataNode, routeData))
            } else {
                self.switchEvent(.lookingBags(dataNode, routeData))
            }

        }
    }

    func colectBag() {
        coletarBag(location) { (bag) in
            self.bags.append(bag)
            self.checkIfisCompleted()
        }
    }
    
}
