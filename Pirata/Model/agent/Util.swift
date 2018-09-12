//
//  Util.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Agent {
    
    func getRoute(toBag bag: Slot, excludeRole: Bool = true) {
        map.calcRoute(from: location, to: bag, excludeRole: excludeRole) { (route) in
            if route.count > 1 {
                self.switchEvent(.goToRoute((route,0)))
            } else {
                self.switchEvent(.start)
            }
        }
    }
    
    func colectBag() {
        map.cleanImage(slot: self.location) { bag in
            self.bags.append(bag!)
            self.checkIfisCompleted()
        }
    }
    
    func checkIfisCompleted() {
        if map.bags.totalSet * 10 == totalCoins {
            if self.isCompleted != true {
                self.isCompleted = true
            }
            self.switchEvent(.completed)
        } else {
            self.switchEvent(.start)
        }
    }
}
