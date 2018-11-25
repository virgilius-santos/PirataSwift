//
//  AgentMap+Extension.swift
//  Pirata
//
//  Created by Virgilius Santos on 23/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Map: AgentMap {

    func getRegion(fromLocation location: Slot) -> Map.RegionList {
        return getRegion(fromLocation: location, offset: 0)
    }

    var matrizSize: Int {
        return matriz.count
    }

    var cheastNumbers: Int {
        return mapSettings.cheastNumbers
    }

    var sideWallPosition: Direction {
        return mapData.sideWallPosition
    }

    var totalSet: Int {
        return mapData.bags.totalSet
    }

    func getSlot(fromIndex index: Index) -> Slot {
        return matriz.getSlot(index)
    }

    /// retorna um novo slot a partir de :
    /// - um slot que sera a referencia inicial
    /// - acao que indicara a distancia em relacao a referencia
    /// - e a direcao em relacao a referencia
    func getSlot(fromIndex index: Index, withMovement movement: Agent.Movement) -> Slot? {
        return matriz.slot(index: index, movement: movement)
    }

    func getBag(slot: Slot) -> Bag {
        let bag = self.mapData.getBag(fromIndex: slot.index)
        return bag
    }

}
