import UIKit

enum ImageType: String, Hashable {
    case chest, blank, empty, pirate, hole, door, wall, bag
    
    var image: UIImage {
        return UIImage(named: self.rawValue) ?? #imageLiteral(resourceName: "Empty")
    }

    var index: Int {
        switch self {
        case .hole:
            return 1
        case .door:
            return 2
        case .bag:
            return 3
        case .wall:
            return 4
        default:
            return 0
        }
    }
}
