//
//  CompleteAction.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

var lastCheastVisited = 0
extension Agent {
    func completedAction() {
        let genetic = Genetic(carga: bags)
        startflip()
        genetic.start { (distributedBags) in
            self.stopflip {
                print("\(#function) - completed\n")
                self.distributedBags = distributedBags
                self.switchEvent(.distributedBags)
            }
        }
    }
    
    func distributedBagsInCheasts() {
        if door == nil || cheasts.count != map.mapSettings.cheastNumbers {
            switchEvent(.start)
            return
        }
        
        for index in 0 ..< distributedBags.count {
            if cheasts[index].isCompleted { continue }
            
            if cheasts[index].slot == self.location {
                let bags = distributedBags[index]
                cheasts[index].add(bags)
                distributedBagsInCheasts()
            } else {
                let slot = cheasts[index].slot
                getRoute(toBag: slot)
            }
            return
        }
        
        if door! != location {
            getRoute(toBag: door!)
            return
        }
        
        print("Completed -\(self.distributedBags.map({$0.reduce(0, {$0+$1.valor})}))\n")
        
    }
    
    
}
