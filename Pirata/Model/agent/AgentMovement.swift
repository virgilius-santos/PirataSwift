//
//  AgentMovement.swift
//  Pirata
//
//  Created by Virgilius Santos on 12/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Agent {
    
//    func move(route: [Slot], index: Int = 0) {
//        let next = index + 1
//        let to = route[next]
//        
//        self.moveView(to: to) {
//            self.processMove(to: to, next: next, route: route)
//        }
//    }
    
//    func holeAction(route: [Slot], index: Int) {
//        if route.count <= index + 2 {
//            print("\(#function) -errorHoleDetected\n \n")
//            switchEvent(.start)
//            return
//        }
//
//        var last = index + 2
//        let from = route[index]
//        var to = route[last]
//
//        if to.type == .buraco {
//            while (to.type == .buraco) {
//                last += 1
//                if last == route.count {
//                    switchEvent(.start)
//                    return
//                }
//                to = route[last]
//            }
//            switchEvent(.goToSlot(to, false))
//            return
//        }
//
//        if from.index.col != to.index.col, from.index.row != to.index.row {
//            switchEvent(.goToSlot(route.last!, false))
//            return
//        }
//
//        jumpView(to: to) {
//            self.holeJumpeds += 1
//            self.processMove(to: to, next: last, route: route)
//        }
//    }

//    func moveOut() {
//        let bagValues = distributedBags.map { (bags) -> Int in
//            return bags.map({$0.valor}).reduce(0,+)
//        }
//
//        let bagCompare = bagValues.reduce(true, {$0 && ($1 == bagValues[0])})
//
//        if bagCompare {
//            self.updateValues(true)
//            let direction: Direction = (map.sideWallPosition == .left || map.sideWallPosition == .right)
//                ? .vertical : .horizontal
//            let value: Float = (map.sideWallPosition == .left || map.sideWallPosition == .up)
//                ? -40 : 40
//            goOut(direction: direction, value: value)
//        }
//    }

}
