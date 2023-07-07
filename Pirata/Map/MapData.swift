//
//  MapData.swift
//  Pirata
//
//  Created by Virgilius Santos on 23/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct MapData {

    var sideWallPosition: Direction!
    var doorLocation: Int!
    var bags: Bags!

    func getBag(fromIndex index: Index) -> Bag {
        let bag = bags.data.first(where: {$0.index == index})
        return bag!
    }
}
