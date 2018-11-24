//
//  AgentProcess.swift
//  Pirata
//
//  Created by Virgilius Santos on 11/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

//extension Agent {

//    func switchEvent(_ event: EventType) {
//        if stopped {
//            return
//        }
//
//        switch event {
//        case .start:
//            self.analiseRegion()
//
//        case .lookingBags(let (dataNode, routeData)):
//            self.processRegionLookingBags(dataNode: dataNode, routeData)
//            break
//
//        case .lookingCheastAndDoors(let (dataNode, routeData)):
//            self.processRegionLookingCheastAndDoor(dataNode: dataNode, routeData)
//            break
//
//        case .goToSlot(let (slot, excludeRole)):
//            self.getRoute(toBag: slot, excludeRole: excludeRole)
//
//        case .goToRoute(let (route, index)):
//            if route[index + 1].type == .buraco {
//                self.holeAction(route: route, index: index)
//            } else {
//                self.move(route: route, index: index)
//            }
//            break
//
//        case .colectBag:
//            self.colectBag()
//
//        case .traveling(let routeData):
//            self.analiseRegion(routeData)
//
//        case .randomBags(let dataNode):
//            self.randomSlot(dataNode)
//
//        case .completed:
//            self.completedAction()
//            break
//
//        case .distributedBags:
//            //                self.distributedBagsInCheasts()
//            break
//        }

//    }

//    func analiseRegion(_ routeData: Map.RouteData? = nil) {
//        getRegion { (regionList) in
//
//            self.processRegion(regionList)
//
//            let dataNode: [DataNode] =
//                regionList.getEmptyIndex()
//                    .map { slot in
//                        let distance = slot.index.calcDistance(from: self.location.index)
//                        return DataNode(slot: slot, distance: distance)
//                    }
//                    .sorted(by: {$0.distance < $1.distance})
//
//
//            if self.isCompleted {
//                self.switchEvent(.lookingCheastAndDoors(dataNode, routeData))
//            } else {
//                self.switchEvent(.lookingBags(dataNode, routeData))
//            }
//
//        }
//    }
//
//    func processMove(to: Slot, next: Int, route: [Slot]) {
//        self.location = to
//        if to.type == .saco {
//            self.switchEvent(.colectBag)
//        } else if next+1 < route.count {
//            switchEvent(.traveling((route, next)))
//        } else if isCompleted {
//            switchEvent(.distributedBags)
//        } else {
//            switchEvent(.start)
//        }
//    }
//
//    func processRegion(_ regionList: Map.RegionList) {
//        regionList.forEach { (slot) in
//            if slot.type == .bau, !self.cheasts.contains(where: {$0.slot == slot}) {
//                let cheast = Cheast(slot)
//                self.cheasts.append(cheast)
//                self.bauLocalizado()
//            } else if slot.type == .porta {
//                self.door = slot
//                self.portaLocalizada()
//            }
//        }
//    }
//
//    func processRegionLookingBags(dataNode: [DataNode], _ routeData: Map.RouteData?) {
//
//        if routeData?.route.last?.type == .saco {
//            switchEvent(.goToRoute(routeData!))
//            return
//        }
//
//        if let slot = dataNode.first(where: {$0.slot.type == .saco})?.slot {
//            switchEvent(.goToSlot(slot, true))
//            return
//        }
//
//        if routeData != nil {
//            switchEvent(.goToRoute(routeData!))
//            return
//        }
//
//        switchEvent(.randomBags(dataNode))
//    }
//
//    func processRegionLookingCheastAndDoor(dataNode: [DataNode], _ routeData: Map.RouteData?) {

//        if door != nil, cheasts.count == map.mapSettings.cheastNumbers {
//            switchEvent(.distributedBags)
//            return
//        }
//        
//        if routeData != nil {
//            self.switchEvent(.goToRoute(routeData!))
//            return
//        }
//        
//        self.switchEvent(.randomBags(dataNode))
//    }
//}
