//
//  MapAStar.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Map {
    
    /// metodo que calcula e retorna a roda entre dois quadrados
    func calcRoute(from: Slot, to: Slot, excludeRole: Bool = true, completion: @escaping ([Slot])->()) {
        
        /// verifica se a distancia entre os dois slots é 1
        /// se sim, retorna apenas os dois slots
        let distance = calcDistance(from: from.index, to: to.index)
        if distance == 1 {
            completion([from,to])
            return
        }
        
        DispatchQueue(label: "calculate").async {
            
            var route = [DataNode]()
            var open: [DataNode] = []
            var close: [Slot] = []
            
            let first = DataNode(slot: from)
            open.append(first)
            
            
            /// enquanto a lista aberta tiver um DataNode
            while !open.isEmpty {
                
                /// pega o primeiro data node mais proximo
                let current = open.removeFirst()
                
                /// adiciona o slot a lista fechada
                close.append(current.slot)
                
                /// pega o primeiro vizinho,
                /// sem considerar buracos se excludeRole == true
                let vizinhos = self.getVizinhos(current.slot.index, excludeRole: excludeRole)
                
                vizinhos.forEach { (slot) in
                    
                    /// se o slot ja esta na lista fechada
                    /// ele nao é incluido novamente a lista aberta
                    let valid = close.contains(slot)
                    if valid { return }
                    
                    var distance = self.calcDistance(from: from.index, to: slot.index)
                    distance += self.calcDistance(from: slot.index, to: to.index)
                    
                    let data = DataNode(slot: slot, distance: distance, parent: current)
                    
                    /// transforma cada vizinho em um DataNode
                    /// este DataNode possui a informacao do slot
                    /// da distancia e do slot de origem
                    open.append(data)
                    
                }
                
                /// ordena a lista aberta pela menor distancia
                open.sort(by: { (dt1, dt2) -> Bool in
                    return dt1.distance < dt2.distance
                })
                
                /// se o DataNode Current é o destino
                /// o loop é interrompido
                route.append(current)
                if current.slot == to {
                    break
                }
                
            }
            
            /// o caminho é reconstruido a partir do destino
            /// usando os parents do DataNode
            var way = [Slot]()
            var current: DataNode? = route.first(where: {$0.slot == to})
            while ( current != nil ) {
                way.insert(current!.slot, at: 0)
                current = current?.parent
            }
         
            completion(way)
        }
    }
    
    /// verifica e adiciona os vizinhos nas quatro direcoes
    private func getVizinhos(_ current: Index, excludeRole: Bool) -> [Slot] {
        var vizinhos = [Slot]()
        if current.row - 1 >= 0 {
            updateVizinhos(vizinhos: &vizinhos,
                           col: current.col,
                           row: current.row-1,
                           excludeRole: excludeRole)
        }
        if current.row + 1 < matriz[current.col].count {
            updateVizinhos(vizinhos: &vizinhos,
                           col: current.col,
                           row: current.row+1,
                           excludeRole: excludeRole)
        }
        if current.col - 1 >= 0 {
                updateVizinhos(vizinhos: &vizinhos,
                               col: current.col-1,
                               row: current.row,
                               excludeRole: excludeRole)
        }
        if current.col + 1 < matriz.count {
                updateVizinhos(vizinhos: &vizinhos,
                               col: current.col+1,
                               row: current.row,
                               excludeRole: excludeRole)
        }
        return vizinhos
    }
    
    /// atualiza o array de vizinhos se o slot nao representa um muro
    /// e se o vizinho é diferente de um buraco, caso o filtro esteja ativado
    private func updateVizinhos(vizinhos: inout [Slot], col: Int, row: Int, excludeRole: Bool) {
        if matriz[col][row].type != .muro
            && (matriz[col][row].type != .buraco || excludeRole) {
            vizinhos.append(matriz[col][row])
        }
    }
    
    /// calcula a distancia entre dois quadrados
    func calcDistance(from: Index, to: Index) -> Int {
        let colSignal = from.col <= to.col ? 1 : -1
        let rowSignal = from.row <= to.row ? 1 : -1
        let colAux = (to.col - from.col) * colSignal
        let rowAux = (to.row - from.row) * rowSignal
        let soma = colAux + rowAux
        return soma
    }
}
