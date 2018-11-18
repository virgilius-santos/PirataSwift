//
//  Map.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

//protocol MapDelegate {
//    func setImage(with type: ImageType, index: Index)
//    func fadeOut(slot: Slot, speed: Double, completion: @escaping()->())
//    func loadComplete()
//}

class Map {

//    var delegate: MapDelegate?

    lazy var busySlots: Set<Index> = Set<Index>()
    lazy var matriz: [[Slot]] = {
        var matriz = [[Slot]]()
        for col in 0..<mapSettings.square {
            var slots = [Slot]()
            for row in 0..<mapSettings.square {
                let index = Index(col: col, row: row)
                let slot = Slot(index: index)
                slots.append(slot)
            }
            matriz.append(slots)
        }
        return matriz
    }()
    
    var mapSettings: MapSettings
    
    var sideWallPosition: Position!
    var doorLocation: Int!
    var bags: Bags
    
    init(square: Int) {
        self.mapSettings = MapSettings(square: square)
        self.bags = Bags(mapSettings.bagsNumbers)
    }

//    func setImage(with type: ImageType, index: Index) {
//        DispatchQueue.main.async {
//            self.delegate?.setImage(with: type, index: index)
//        }
//    }
//    
//    func cleanImage(slot: Slot, completion: @escaping(Bag?)->()) {
//        DispatchQueue.main.async {
//            self.delegate?.fadeOut(slot: slot, speed: 2) {
//                self.matriz[slot.index.col][slot.index.row].set(type: .Empty)
//                let bag = self.bags.data.first(where: {$0.index == slot.index})
//                completion(bag)
//            }
//        }
//    }
    
    func loadData(completion: @escaping([[Slot]])->()) {
        DispatchQueue(label: "background").async {
            self.makeSideWall()
            
            self.makeDoor()
            
            self.makeCheast()
            
            self.makeInternalWall()
            
            self.makeHole()
            
            self.makeBags()
            
            DispatchQueue.main.async {
                completion(self.matriz)
            }
        }
    }
    
    func isIndexIdle(_ index: Index?) -> Bool {
        guard let idx = index else { return false }
        let localIndex = matriz[idx.col][idx.row].index
        return !busySlots.contains(localIndex)
    }
    
    func addSlot(_ index: Index?, type: ImageType) {
        guard let index = index else {
            return
        }
        matriz[index.col][index.row].set(type: type)
        busySlots.insert(matriz[index.col][index.row].index)
//        setImage(with: type, index: index)
    }
    
    var freeSlot: Slot {
        let slots = getEmptyIndex()
        var slot: Slot?
        repeat {
            let index = randomNumber(slots.count)
            slot = slots[index]
        } while (slot == nil || slot!.type != .Empty)
        return slot!
    }
   
}
