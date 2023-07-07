import Foundation

struct Orientation: Equatable {
    static let horizontal = Orientation(
        value: 0,
        internWall: { row, col, indice in Index(col: col+indice, row: row) }
    )
    static let vertical = Orientation(
        value: 1,
        internWall: { row, col, indice in Index(col: col, row: row+indice) }
    )
    
    static func == (lhs: Orientation, rhs: Orientation) -> Bool {
        lhs.value == rhs.value
    }
    
    let value: Int
    let internWall: (_ row: Int, _ col: Int, _ indice: Int) -> Index
}
