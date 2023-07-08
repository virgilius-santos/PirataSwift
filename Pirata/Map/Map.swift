import UIKit

extension Map {
    /// representa uma lista sequencial de slots
    /// que formam uma Rota
    public typealias Route = [Slot]

    /// representa:
    /// - route: uma lista sequencial de slots
    /// - index: o indice do Slot atual
    public typealias RouteData = (route: Route, index: Array<Slot>.Index)

    /// representa a matriz de slots
    public typealias Region = [[Slot]]

    /// representa a Regiao de slots em torno de um ponto
    public typealias RegionList = [Slot]
    
}

final class Map {
    var matriz: Region = []
    var mapSettings: MapSettings
    var mapData: MapData = MapData()

    convenience init(square: Int) {
        self.init(mapSettings: MapSettings(square: square))
    }
    
    init(mapSettings: MapSettings) {
        self.mapSettings = mapSettings
        self.mapData.bags = Bags(mapSettings.bagsNumbers)
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

    func fillMatriz() {
        matriz = generateMatriz(
            nCols: mapSettings.columns,
            nRows: mapSettings.rows
        )
    }
    
    func loadData() -> Region {
        makeSideWall()
        makeDoor()
        makeCheast()
        makeInternalWall()
        makeHole()
        makeBags()
        return matriz
    }
}
