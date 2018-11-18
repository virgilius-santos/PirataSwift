//
//  ImageType.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

enum ImageType: String {
    case bau, blank, Empty, pirate, buraco, porta, muro, saco
    
    var image: UIImage {
        return UIImage(named: self.rawValue) ?? #imageLiteral(resourceName: "Empty")
    }

    var index: Int {
        switch self {
        case .buraco:
            return 1
        case .porta:
            return 2
        case .saco:
            return 3
        case .muro:
            return 4
        default:
            return 0
        }
    }
}
