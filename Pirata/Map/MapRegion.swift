//
//  MapRegion.swift
//  Pirata
//
//  Created by Virgilius Santos on 08/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Map {
    func getRegion(_ slot: Slot, completion: @escaping (RegionList)->()) {
        DispatchQueue(label: "region").async {
            
            let index = slot.index
            var region = RegionList()
            var aux: Index

            if let slot = self.matriz.upSlot(fromIndex: index) {
                region.append(slot)
            }
            aux = Index(col: index.col, row: index.row-1)
            if let slot = self.matriz.upSlot(fromIndex: aux) {
                region.append(slot)
            }

            if let slot = self.matriz.downSlot(fromIndex: index) {
                region.append(slot)
            }
            aux = Index(col: index.col, row: index.row+1)
            if let slot = self.matriz.downSlot(fromIndex: aux) {
                region.append(slot)
            }

            if let slot = self.matriz.leftSlot(fromIndex: index) {
                region.append(slot)
            }
            aux = Index(col: index.col-1, row: index.row)
            if let slot = self.matriz.leftSlot(fromIndex: aux) {
                region.append(slot)
            }

            if let slot = self.matriz.rightSlot(fromIndex: index) {
                region.append(slot)
            }
            aux = Index(col: index.col+1, row: index.row)
            if let slot = self.matriz.rightSlot(fromIndex: aux) {
                region.append(slot)
            }

            completion(region)
        }
    }
}
