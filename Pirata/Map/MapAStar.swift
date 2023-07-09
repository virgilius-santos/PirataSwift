import Foundation

extension Map {
    /// metodo que calcula e retorna a roda entre dois quadrados
    /// usando o Algoritmo A*
    func getRoute(from: Slot, to: Slot, excludeRole: Bool = true) -> Route {
        
        /// verifica se a distancia entre os dois slots é 1
        /// se sim, retorna apenas os dois slots
        let distance = from.index.calcDistance(to: to.index)
        if distance == 1 {
            return [from, to]
        }
        
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
                
                var distance = slot.index.calcDistance(from: from.index)
                distance += slot.index.calcDistance(to: to.index)
                
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
        var way = Route()
        var current: DataNode? = route.first(where: {$0.slot == to})
        while current != nil {
            way.insert(current!.slot, at: 0)
            current = current?.parent
        }
        
        return way
    }
    
    /// verifica e adiciona os vizinhos nas quatro direcoes
    private func getVizinhos(_ current: Index, excludeRole: Bool) -> [Slot] {
        var vizinhos = [Slot]()
        if let slot = matriz.upSlot(fromIndex: current) {
            updateVizinhos(vizinhos: &vizinhos,
                           slot: slot,
                           excludeRole: excludeRole)
        }
        if let slot = matriz.downSlot(fromIndex: current) {
            updateVizinhos(vizinhos: &vizinhos,
                           slot: slot,
                           excludeRole: excludeRole)
        }
        if let slot = matriz.leftSlot(fromIndex: current) {
            updateVizinhos(vizinhos: &vizinhos,
                           slot: slot,
                           excludeRole: excludeRole)
        }
        if let slot = matriz.rightSlot(fromIndex: current) {
            updateVizinhos(vizinhos: &vizinhos,
                           slot: slot,
                           excludeRole: excludeRole)
        }
        return vizinhos
    }
    
    /// atualiza o array de vizinhos se o slot nao representa um muro
    /// e se o vizinho é diferente de um buraco, caso o filtro esteja ativado
    private func updateVizinhos(vizinhos: inout [Slot], slot: Slot, excludeRole: Bool) {
        if slot.type != .wall
            && (slot.type != .hole || excludeRole) {
            vizinhos.append(slot)
        }
    }

}
