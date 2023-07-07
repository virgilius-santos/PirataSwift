import Foundation

extension Map: AgentMap {
    func getRegion(fromLocation location: Slot) -> Map.RegionList {
        getRegion(fromLocation: location, offset: 0)
    }

    var matrizSize: Int {
        matriz.count
    }

    var cheastNumbers: Int {
        mapSettings.cheastNumbers
    }

    var sideWallPosition: Direction {
        mapData.sideWallPosition
    }

    var totalSet: Int {
        mapData.bags.totalSet
    }

    func getSlot(fromIndex index: Index) -> Slot {
        matriz.getSlot(index)
    }

    /// retorna um novo slot a partir de :
    /// - um slot que sera a referencia inicial
    /// - acao que indicara a distancia em relacao a referencia
    /// - e a direcao em relacao a referencia
    func getSlot(fromIndex index: Index, withMovement movement: Agent.Movement) -> Slot? {
        matriz.slot(index: index, movement: movement)
    }

    func getBag(slot: Slot) -> Bag {
        mapData.getBag(fromIndex: slot.index)
    }

}
