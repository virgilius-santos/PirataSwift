//
//  AgentAccessMap.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

protocol AgentMap: class {
    var matrizSize: Int { get }
    var cheastNumbers: Int { get }
    var sideWallPosition: Direction { get }
    var totalSet: Int { get }

    func getRegion(fromLocation location: Slot) -> Map.RegionList

    func getRoute(from: Slot, to: Slot, excludeRole: Bool,
                  completion: @escaping (Map.Route)->())


    func getBag(slot: Slot) -> Bag

    func getSlot(fromIndex index: Index) -> Slot

    func getSlot(fromIndex: Index, withMovement movement: Agent.Movement) -> Slot?
}
