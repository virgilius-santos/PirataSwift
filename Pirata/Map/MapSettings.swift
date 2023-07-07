import Foundation

struct MapSettings {
    let rows: Int
    let columns: Int
    let cheastNumbers: Int
    let internalWallNumbers: Int
    let internalWallLenght: Int
    let holeNumbers: Int
    let bagsNumbers: Int
}

extension MapSettings {
    init(square: Int) {
        self.rows = square
        self.columns = square
        self.cheastNumbers = 0
        self.internalWallNumbers = 0
        self.internalWallLenght = 5
        self.holeNumbers = 4
        self.bagsNumbers = 5
    }
}
