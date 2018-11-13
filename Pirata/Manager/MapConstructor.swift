//
//  MapConstructor.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Map {
    
    /// gera o muro lateral
    func makeSideWall() {
        // gera a direcao do paredao e seta a parede no jogo
        sideWallPosition = Position.down
        for aux in 0 ..< mapSettings.square {
            let index = sideWallPosition.sideWall(limit: mapSettings.square, value: aux)
            addSlot(index, type: .muro)
        }
        sideWallPosition = Position.left
        for aux in 0 ..< mapSettings.square {
            let index = sideWallPosition.sideWall(limit: mapSettings.square, value: aux)
            addSlot(index, type: .muro)
        }
        sideWallPosition = Position.up
        for aux in 0 ..< mapSettings.square {
            let index = sideWallPosition.sideWall(limit: mapSettings.square, value: aux)
            addSlot(index, type: .muro)
        }
        sideWallPosition = Position.right
        for aux in 0 ..< mapSettings.square {
            let index = sideWallPosition.sideWall(limit: mapSettings.square, value: aux)
            addSlot(index, type: .muro)
        }
        print("\(#function) - completo")
    }
    
    /// gera a porta que fica no muro lateral
    func makeDoor() {
        // gera o index da porta no paredao
        let index = Index(col: 1, row: 8)
        addSlot(index, type: .porta)
        print("\(#function) - completo")
    }
    
    /// cria os baus na arena
    func makeCheast() {
//        var aux = 0
//        // gera os index dos baus
//        while (aux < mapSettings.cheastNumbers) {
//            let value = mock ? mockCheast[aux] : randomNumber(mapSettings.square)
//            if doorLocation == value { continue }
//
//            let index = sideWallPosition.cheast(limit: mapSettings.square, value: value)
//            if !isIndexIdle(index) { continue }
//
//            addSlot(index, type: .bau)
//            aux += 1
//        }
//        print("\(#function) - completo")
    }
    
    /// cria paredes internas
    func makeInternalWall() {
        var index: Index

        // constroi uma parede com comprimento 10
        for i in 0 ..< 10 {
            index = Direction.vertical.internWall(row: 0, col: 4, indice: i)
            addSlot(index, type: .muro)
        }

        // constroi uma parede com comprimento 2
        for i in 0 ..< 2 {
            index = Direction.horizontal.internWall(row: 1, col: 2, indice: i)
            addSlot(index, type: .muro)
        }
        // constroi uma parede com comprimento 2
        for i in 0 ..< 2 {
            index = Direction.horizontal.internWall(row: 5, col: 2, indice: i)
            addSlot(index, type: .muro)
        }
        // constroi uma parede com comprimento 2
        for i in 0 ..< 2 {
            index = Direction.horizontal.internWall(row: 3, col: 1, indice: i)
            addSlot(index, type: .muro)
        }
        // constroi uma parede com comprimento 2
        for i in 0 ..< 2 {
            index = Direction.horizontal.internWall(row: 7, col: 1, indice: i)
            addSlot(index, type: .muro)
        }

        print("\(#function) - completo")
    }
    
    /// cria os buracos na arena
    func makeHole() {
        
        addSlot(Index(col: 2, row: 2), type: .buraco)
        addSlot(Index(col: 2, row: 4), type: .buraco)
        addSlot(Index(col: 1, row: 5), type: .buraco)
        addSlot(Index(col: 3, row: 7), type: .buraco)
        print("\(#function) - completo")
    }
    
    /// coloca os sacos de din din na arena
    func makeBags() {
        addSlot(Index(col: 3, row: 3), type: .saco)
        addSlot(Index(col: 3, row: 4), type: .saco)
        addSlot(Index(col: 3, row: 6), type: .saco)
        addSlot(Index(col: 1, row: 6), type: .saco)
        addSlot(Index(col: 2, row: 8), type: .saco)
        
        print("\(#function) - completo")
    }
}
