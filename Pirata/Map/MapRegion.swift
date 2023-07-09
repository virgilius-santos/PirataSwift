import Foundation

extension Map {
    func getRegion(fromLocation slot: Slot, offset: Int) -> RegionList {

        if offset < 0 {
            return RegionList()
        }

        let index = slot.index
        var region = RegionList()
        var aux: Index

        aux = Index(col: index.col, row: index.row+offset)
        if let slot = self.matriz.downSlot(fromIndex: aux) {
            region.append(slot)
        }

        aux = Index(col: index.col-offset, row: index.row)
        if let slot = self.matriz.leftSlot(fromIndex: aux) {
            region.append(slot)
        }

        aux = Index(col: index.col+offset, row: index.row)
        if let slot = self.matriz.rightSlot(fromIndex: aux) {
            region.append(slot)
        }

        let nextRegion = getRegion(fromLocation: slot, offset: offset-1)
        region.append(contentsOf: nextRegion)
        return region
    }
}
