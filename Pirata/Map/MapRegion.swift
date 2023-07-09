import Foundation

extension Map {
    func getRegion(fromLocation slot: Slot, offset: Int) -> RegionList {

        if offset < 0 {
            return RegionList()
        }

        let index = slot.index
        var region = RegionList()
        var aux: Index

        aux = Index(col: index.col, row: index.row-offset)
        if let slot = matriz.upSlot(fromIndex: aux) {
            region.append(slot)
        }
        
        aux = Index(col: index.col, row: index.row+offset)
        if let slot = matriz.downSlot(fromIndex: aux) {
            region.append(slot)
        }

        aux = Index(col: index.col-offset, row: index.row)
        if let slot = matriz.leftSlot(fromIndex: aux) {
            region.append(slot)
        }

        aux = Index(col: index.col+offset, row: index.row)
        if let slot = matriz.rightSlot(fromIndex: aux) {
            region.append(slot)
        }

        let nextRegion = getRegion(fromLocation: slot, offset: offset-1)
        region.append(contentsOf: nextRegion)
        return region
    }
}
