//
//  AgentMovement.swift
//  Pirata
//
//  Created by Virgilius Santos on 12/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Agent {
    
    func move(route: [Slot], index: Int = 0) {
        let next = index + 1
        let to = route[next]
        
        self.moveView(to: to) {
            self.processMove(to: to, next: next, route: route)
        }
    }
    
    func holeAction(route: [Slot], index: Int) {
        if route.count <= index + 2 {
            print("\(#function) -errorHoleDetected\n \n")
            switchEvent(.start)
            return
        }
        
        var last = index + 2
        let from = route[index]
        var to = route[last]
        
        if to.type == .buraco {
            while (to.type == .buraco) {
                last += 1
                if last == route.count {
                    switchEvent(.start)
                    return
                }
                to = route[last]
            }
            switchEvent(.goToSlot(to, false))
            return
        }
        
        if from.index.col != to.index.col, from.index.row != to.index.row {
            switchEvent(.goToSlot(to, false))
            return
        }
        
        jumpView(to: to) {
            self.holeJumpeds += 1
            self.processMove(to: to, next: last, route: route)
        }
    }
    
    func processMove(to: Slot, next: Int, route: [Slot]) {
        self.location = to
        if to.type == .saco {
            self.switchEvent(.colectBag)
        } else if next+1 < route.count {
            switchEvent(.traveling((route, next)))
        } else if isCompleted {
            switchEvent(.distributedBags)
        } else {
            switchEvent(.start)
        }
    }
    
}
