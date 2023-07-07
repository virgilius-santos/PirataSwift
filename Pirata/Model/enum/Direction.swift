import Foundation

enum Direction: Int, CaseIterable {
    case left, right, down, up, none
    
    func sideWall(limit: Int, value: Int) -> Index {
        switch self {
        case .left:
            return Index(col: 0, row: value)
        case .right:
            return Index(col: limit-1, row: value)
        case .up:
            return Index(col: value, row: 0)
        case .down:
            return Index(col: value, row: limit-1)
        case .none:
            return Index(col: 0, row: 0)
        }
    }
    
    func door(limit: Int, value: Int) -> Index {
        switch self {
        case .left:
            return Index(col: 0, row: value)
        case .right:
            return Index(col: limit-1, row: value)
        case .up:
            return Index(col: value, row: 0)
        case .down:
            return Index(col: value, row: limit-1)
        case .none:
            return Index(col: 0, row: 0)
        }
    }
    
    func cheast(limit: Int, value: Int) -> Index {
        switch self {
        case .left:
            return Index(col: 1, row: value)
        case .right:
            return Index(col: limit-2, row: value)
        case .up:
            return Index(col: value, row: 1)
        case .down:
            return Index(col: value, row: limit-2)
        case .none:
            return Index(col: 0, row: 0)
        }
    }
}
