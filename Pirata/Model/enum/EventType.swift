//
//  EventType.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

enum EventType {
    case start
    case goToRoute(([Slot], Int))
    case goToSlot(Slot, Bool)
    case colectBag
    case traveling(([Slot], Int))
    case randomBags([DataNode])
    case completed
    case distributedBags
}
