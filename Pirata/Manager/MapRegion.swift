//
//  MapRegion.swift
//  Pirata
//
//  Created by Virgilius Santos on 08/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

typealias Region = [[Slot]]
extension Map {
    func getRegion(_ slot: Slot, completion: @escaping (Region)->()) {
        DispatchQueue(label: "region").async {
            
            let index = slot.index
            var region = Region()
            region.removeAll()
            
            var colStart = index.col - 2
            colStart = colStart < 0 ? 0 : colStart
            
            var colEnd = index.col + 2
            colEnd = colEnd >= self.matriz.count ? self.matriz.count-1 : colEnd
            
            var rowStart = index.row - 2
            rowStart = rowStart < 0 ? 0 : rowStart
            
            var rowEnd = index.row + 2
            rowEnd = rowEnd >= self.matriz[colEnd].count ? self.matriz[colEnd].count-1 : rowEnd
            
            for i in colStart ... colEnd {
                var line = [Slot]()
                for j in rowStart ... rowEnd {
                    if self.matriz[i][j].type != .muro {
                        line.append(self.matriz[i][j])
                    }
                }
                region.append(line)
            }
            
            completion(region)
        }
    }
}
