//
//  RandomAgent.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

private var direction: Position = .up
var change: Bool = true

extension Agent {
    
    func randomSlot(_ region: [DataNode]) {
        
        switch direction {
        case .left:
            goToLeft(region)
            break
        case .right:
            goToRight(region)
            break
        case .up:
            goToUp(region)
            break
        case .down:
            goToDown(region)
            break
        }
        
    }
    
    private func goToUp(_ region: [DataNode]) {
        let sorted = region.sorted(by: {
            ($0.slot.index.row == $1.slot.index.row)
                ? (change ? $0.slot.index.col > $1.slot.index.col : $0.slot.index.col < $1.slot.index.col)
                : $0.slot.index.row < $1.slot.index.row })
        
        guard let first = sorted.first, location.index.row > 2 else {
            updateDirection(.left)
            randomSlot(region)
            return
        }
        
        change = !change
        updateDirection(direction)
        switchEvent(.goToSlot(first.slot, true))
    }
    
    private func goToLeft(_ region: [DataNode]) {
        let sorted = region.sorted(by: {
            ($0.slot.index.col == $1.slot.index.col)
                ? (change ? $0.slot.index.row < $1.slot.index.row : $0.slot.index.row > $1.slot.index.row)
                : $0.slot.index.col < $1.slot.index.col })
        
        guard let first = sorted.first, location.index.col > 2 else {
            updateDirection(.down)
            randomSlot(region)
            return
        }
        
        change = !change
        updateDirection(direction)
        switchEvent(.goToSlot(first.slot, true))
    }
    
    private func goToDown(_ region: [DataNode]) {
        let sorted = region.sorted(by: {
            ($0.slot.index.row == $1.slot.index.row)
                ? (change ? $0.slot.index.col > $1.slot.index.col : $0.slot.index.col < $1.slot.index.col)
                : $0.slot.index.row > $1.slot.index.row })
        
        guard let first = sorted.first, location.index.row < map.matriz.count - 2 else {
            updateDirection(.right)
            randomSlot(region)
            return
        }
        
        change = !change
        updateDirection(direction)
        switchEvent(.goToSlot(first.slot, true))
    }
    
    private func goToRight(_ region: [DataNode]) {
        let sorted = region.sorted(by: {
            ($0.slot.index.col == $1.slot.index.col)
                ? (change ? $0.slot.index.row < $1.slot.index.row : $0.slot.index.row > $1.slot.index.row)
                : $0.slot.index.col > $1.slot.index.col })
        
        guard let first = sorted.first, location.index.col < map.matriz.count - 2 else {
            updateDirection(.up)
            randomSlot(region)
            return
        }
        
        change = !change
        updateDirection(direction)
        switchEvent(.goToSlot(first.slot, true))
    }
    
    func updateDirection(_ position: Position) {
        direction = (arc4random_uniform(100) < 10)
            ? Position(rawValue: Int(arc4random_uniform(4)))!
            : position
    }
}

























