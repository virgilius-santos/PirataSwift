//
//  ImageType.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

enum ImageType: String {
    case bau, blank, buraco, Empty, muro, pirate, porta, saco
    
    var image: UIImage {
        return UIImage(named: self.rawValue) ?? #imageLiteral(resourceName: "Empty")
    }
}
