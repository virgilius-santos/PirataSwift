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
        mapData.sideWallPosition = Direction.down
        for aux in 0 ..< mapSettings.rows {
            let index = sideWallPosition.sideWall(limit: mapSettings.rows, value: aux)
            matriz.setSlot(index, type: .wall)
        }
        mapData.sideWallPosition = Direction.left
        for aux in 0 ..< mapSettings.columns {
            let index = sideWallPosition.sideWall(limit: mapSettings.columns, value: aux)
            matriz.setSlot(index, type: .wall)
        }
        mapData.sideWallPosition = Direction.up
        for aux in 0 ..< mapSettings.rows {
            let index = sideWallPosition.sideWall(limit: mapSettings.rows, value: aux)
            matriz.setSlot(index, type: .wall)
        }
        mapData.sideWallPosition = Direction.right
        for aux in 0 ..< mapSettings.columns {
            let index = sideWallPosition.sideWall(limit: mapSettings.columns, value: aux)
            matriz.setSlot(index, type: .wall)
        }
//        print("\(#function) - completo")
    }
    
    /// gera a porta que fica no muro lateral
    func makeDoor() {
        // gera o index da porta no paredao
        let index = Index(col: 1, row: 8)
        matriz.setSlot(index, type: .door)
//        print("\(#function) - completo")
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
            index = Orientation.vertical.internWall(0, 4, i)
            matriz.setSlot(index, type: .wall)
        }

        // constroi uma parede com comprimento 2
        for i in 0 ..< 2 {
            index = Orientation.horizontal.internWall(1, 2, i)
            matriz.setSlot(index, type: .wall)
        }
        // constroi uma parede com comprimento 2
        for i in 0 ..< 2 {
            index = Orientation.horizontal.internWall(5, 2, i)
            matriz.setSlot(index, type: .wall)
        }
        // constroi uma parede com comprimento 2
        for i in 0 ..< 2 {
            index = Orientation.horizontal.internWall(3, 1, i)
            matriz.setSlot(index, type: .wall)
        }
        // constroi uma parede com comprimento 2
        for i in 0 ..< 2 {
            index = Orientation.horizontal.internWall(7, 1, i)
            matriz.setSlot(index, type: .wall)
        }

//        print("\(#function) - completo")
    }
    
    /// cria os buracos na arena
    func makeHole() {
        
        matriz.setSlot(Index(col: 2, row: 2), type: .hole)
        matriz.setSlot(Index(col: 2, row: 4), type: .hole)
        matriz.setSlot(Index(col: 1, row: 5), type: .hole)
        matriz.setSlot(Index(col: 3, row: 7), type: .hole)
//        print("\(#function) - completo")
    }
    
    /// coloca os sacos de din din na arena
    func makeBags() {

        var index = Index(col: 3, row: 3)
        mapData.bags.data[4].index = index
        matriz.setSlot(index, type: .bag)

        index = Index(col: 2, row: 8)
        mapData.bags.data[3].index = index
        matriz.setSlot(index, type: .bag)

        index = Index(col: 1, row: 6)
        mapData.bags.data[2].index = index
        matriz.setSlot(index, type: .bag)

        index = Index(col: 3, row: 6)
        mapData.bags.data[1].index = index
        matriz.setSlot(index, type: .bag)

        index = Index(col: 3, row: 4)
        mapData.bags.data[0].index = index
        matriz.setSlot(index, type: .bag)
        
//        print("\(#function) - completo")
    }
}
