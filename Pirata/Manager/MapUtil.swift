//
//  MapCheck.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Map {
    
    /// verifica se a matriz é um grafo conexo
    func checkMatriz(_ emptySlots: [Slot]) -> Bool{
        
        var emptyIndex = emptySlots.map({$0.index})
        if emptyIndex.isEmpty { return false }
        
        var fila = [Index]()
        fila.append(emptyIndex.removeFirst())
        
        while !fila.isEmpty {
            let current = fila.removeFirst()
            if let index = emptyIndex.index(where: {$0.col == current.col+1 && $0.row == current.row}) {
                let data = emptyIndex.remove(at: index)
                fila.append(data)
            }
            if let index = emptyIndex.index(where: {$0.col == current.col-1 && $0.row == current.row}) {
                let data = emptyIndex.remove(at: index)
                fila.append(data)
            }
            if let index = emptyIndex.index(where: {$0.row == current.row+1 && $0.col == current.col}) {
                let data = emptyIndex.remove(at: index)
                fila.append(data)
            }
            if let index = emptyIndex.index(where: {$0.row == current.row-1 && $0.col == current.col}) {
                let data = emptyIndex.remove(at: index)
                fila.append(data)
            }
        }
        
        return emptyIndex.isEmpty
    }
    
    /// busca todos os index nao ocupados
    func getEmptyIndex(_ indexExcludeds: [Index] = [],
                       excludeDoor:Bool=false,
                       excludeHole:Bool=false,
                       excludeCheast:Bool=false) -> [Slot] {
        
        // converte a matriz em um array
        let slots: [Slot] = matriz.flatMap({$0})
        
        // filtra os slots
        let filtered = slots.filter { (slot) -> Bool in
            if indexExcludeds.contains(slot.index) { return false }
            
            if slot.type == .muro { return false }
            
            if excludeCheast, slot.type == .bau { return false }
            
            if excludeHole, slot.type == .buraco { return false }
            
            return true
        }
        
        return filtered
    }
}







