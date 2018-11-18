//
//  Map.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

extension Map {

    /// representa uma lista sequencial de slots
    /// que formam uma Rota
    public typealias Route = [Slot]

    /// representa:
    /// uma lista sequencial de slots
    /// o indice do Slot atual
    public typealias RouteData = (route: Route, index: Array<Slot>.Index)

    /// representa a matriz de slots
    public typealias Region = [[Slot]]

    /// representa a list de slots
    public typealias RegionList = [Slot]
    
}

class Map {

    var matriz: Region = []
    
    var mapSettings: MapSettings
    
    var sideWallPosition: Direction!
    var doorLocation: Int!
    var bags: Bags
    
    init(square: Int) {
        self.mapSettings = MapSettings(square: square)
        self.bags = Bags(mapSettings.bagsNumbers)
    }

    func generateMatriz(nCols: Int, nRows: Int) -> Region {
        var matriz = Region()
        for col in 0..<nCols {
            var slots = [Slot]()
            for row in 0..<nRows {
                let index = Index(col: col, row: row)
                let slot = Slot(index: index)
                slots.append(slot)
            }
            matriz.append(slots)
        }
        return matriz
    }

    func completeMatriz() {
        self.matriz = self.generateMatriz(nCols: self.mapSettings.square,
                                          nRows: self.mapSettings.square)
    }
    
    func loadData(completion: @escaping(Region)->()) {
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

    func getBag(slot: Slot) -> Bag {
        self.matriz[slot.index.col][slot.index.row].set(type: .Empty)
        let bag = self.bags.data.first(where: {$0.index == slot.index})
        return bag!
    }
}

//    func isIndexIdle(_ index: Index?) -> Bool {
//        guard let idx = index else { return false }
//        return !matriz[idx.col][idx.row].isBusy
//    }


//    var freeSlot: Slot {
//        let slots = matriz.getEmptyIndex()
//        var slot: Slot?
//        repeat {
//            let index = randomNumber(slots.count)
//            slot = slots[index]
//        } while (slot == nil || slot!.type != .Empty)
//        return slot!
//    }


//    func addSlot(_ index: Index?, type: ImageType) {
//        guard let index = index else {
//            return
//        }
//        matriz[index.col][index.row].set(type: type)
//        matriz[index.col][index.row].setBusy()
//        //busySlots.insert(matriz[index.col][index.row].index)
//    }


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
