//
//  AgentAccessMap.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Agent {

    var matrizSize: Int { return map.matriz.count }

    var cheastNumbers: Int { return map.mapSettings.cheastNumbers }

    var sideWallPosition: Position { return map.sideWallPosition }

    func getRegion(completion: @escaping (Map.RegionList)->()) {
        map.getRegion(location) { (regionList) in
            completion(regionList)
        }
    }

    func getRoute(toBag bag: Slot, excludeRole: Bool = true) {
        map.getRoute(from: location, to: bag, excludeRole: excludeRole) { (route) in
            if route.count > 1 {
                self.switchEvent(.goToRoute((route,0)))
            } else {
                self.switchEvent(.start)
            }
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
