//
//  MapConstructor.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

var mock: Bool { return false }

extension Map {
    
    /// gera o muro lateral
    func makeSideWall() {
        // gera a direcao do paredao e seta a parede no jogo
        sideWallPosition = mock ? .left : Position(rawValue: Int(arc4random_uniform(4)))
        for aux in 0 ..< mapSettings.square {
            let index = sideWallPosition.sideWall(limit: mapSettings.square, value: aux)
            addSlot(index, type: .muro)
        }
        print("\(#function) - completo")
    }
    
    /// gera a porta que fica no muro lateral
    func makeDoor() {
        // gera o index da porta no paredao
        doorLocation = mock ? 0 : Int(arc4random_uniform(UInt32(mapSettings.square)))
        let index = sideWallPosition.door(limit: mapSettings.square, value: doorLocation)
        addSlot(index, type: .porta)
        print("\(#function) - completo")
    }
    
    var mockCheast: [Int] { return [9,8,7,6]}
    /// cria os baus na arena
    func makeCheast() {
        var aux = 0
        // gera os index dos baus
        while (aux < mapSettings.cheastNumbers) {
            let value = mock ? mockCheast[aux] : Int(arc4random_uniform(UInt32(mapSettings.square)))
            if doorLocation == value { continue }
            
            let index = sideWallPosition.cheast(limit: mapSettings.square, value: value)
            if !isIndexIdle(index) { continue }
            
            addSlot(index, type: .bau)
            aux += 1
        }
        print("\(#function) - completo")
    }
    
    var mockDir: [Direction?] { return [.horizontal, .vertical, .vertical, .vertical] }
    var mockCol: [Int] { return [2, 7, 9, 3] }
    var mockRow: [Int] { return [3, 1, 5, 4] }
    /// cria paredes internas
    func makeInternalWall() {
        var index: Index
        var aux = 0
        // gera os index dos baus
        while (aux < mapSettings.internalWallNumbers) {
            
            // seleciona uma direcao aleatoria pra parede interna
            guard let direction = mock ? mockDir[aux] : Direction(rawValue: Int(arc4random_uniform(4)))
                else { continue }
            
            // seleciona um ponto que sera a linha ou coluna de acordo com a direcao
            let column = mock ? mockCol[aux] : Int(arc4random_uniform(UInt32(mapSettings.square)))
            let row = mock ? mockRow[aux] : Int(arc4random_uniform(UInt32(mapSettings.square)))

            if matriz[column][row].type != .Empty { continue }

            var indexParedeInterna = [Index]()

            // tenta construir uma parede com comprimento 5
            for i in 0 ..< mapSettings.internalWallLenght {
                index = direction.internWall(row: row, col: column, indice: i)
                if index.col < 0 || index.col >= matriz.count {
                    break
                }
                if index.row < 0 || index.row >= matriz[index.col].count {
                    break
                }
                if matriz[index.col][index.row].type != .Empty {
                    break
                }
                indexParedeInterna.append(index)
            }

            // verifica se a parete tem o comprimento correto
            if indexParedeInterna.count != mapSettings.internalWallLenght {
                continue
            }

            let emptyIndex = getEmptyIndex(indexParedeInterna, excludeCheast: true)

            // verifica se gerou beco sem saida
            if !checkMatriz(emptyIndex) {
                continue
            }

            indexParedeInterna.forEach({ addSlot($0, type: .muro) })

            aux += 1
        }
        
        print("\(#function) - completo")
    }
    
    
    func mockHole(_ data: [Slot], aux: Int) -> Int {
        let mockCol = [5,5,5,5,5]
        let mockRow = [6,7,9,8,5]
        let index = data.index(where: { (slot) -> Bool in
            return (slot.index.col == mockCol[aux] && slot.index.row == mockRow[aux])
        }) ?? 0
        print("\(#function) - completo")
        return index
        
    }
    
    /// cria os buracos na arena
    func makeHole() {
        
        var aux = 0
        while (aux < mapSettings.holeNumbers) {
            var emptyIndex = getEmptyIndex(excludeHole: true, excludeCheast: true)
            let pos = mock ? mockHole(emptyIndex,aux: aux) : Int(arc4random_uniform(UInt32(emptyIndex.count)))
            let slot = emptyIndex.remove(at: pos)
            let index = slot.index
            // verifica se gerou beco sem saida
            if matriz[index.col][index.row].type != .Empty || !checkMatriz(emptyIndex) {
                emptyIndex.append(slot)
                continue
            }
            
            addSlot(index, type: .buraco)

            aux += 1
        }
        print("\(#function) - completo")
    }
    
    var mockBagsIndex: [Int] { return [0,1,2,3,4,5,6,7,8,
                                  9,10,11,12,13,14,15] }
    func mockBags(_ empty: [Slot]) -> [Slot] {
        let mocksEmptys = [empty.first(where: {$0.index.col==7 && $0.index.row==9}), //1
                           empty.first(where: {$0.index.col==8 && $0.index.row==9}), //2
                           empty.first(where: {$0.index.col==8 && $0.index.row==8}), //3
                           empty.first(where: {$0.index.col==8 && $0.index.row==7}), //4
                           empty.first(where: {$0.index.col==8 && $0.index.row==6}), //5
                           empty.first(where: {$0.index.col==8 && $0.index.row==5}), //6
                           empty.first(where: {$0.index.col==8 && $0.index.row==4}), //7
                           empty.first(where: {$0.index.col==8 && $0.index.row==3}), //8
                           empty.first(where: {$0.index.col==8 && $0.index.row==2}), //9
                           empty.first(where: {$0.index.col==8 && $0.index.row==1}), //10
                           empty.first(where: {$0.index.col==6 && $0.index.row==9}), //11
                           empty.first(where: {$0.index.col==9 && $0.index.row==0}), //12
                           empty.first(where: {$0.index.col==9 && $0.index.row==1}), //13
                           empty.first(where: {$0.index.col==9 && $0.index.row==2}), //14
                           empty.first(where: {$0.index.col==9 && $0.index.row==3}), //15
                           empty.first(where: {$0.index.col==9 && $0.index.row==4})] //16
        
        return mocksEmptys.compactMap({$0})
    }
    
    /// coloca os sacos de din din na arena
    func makeBags() {
        var aux = 0
        while aux < bags.data.count {
            var emptyIndex = mock ? mockBags(getEmptyIndex()) : getEmptyIndex()
            let pos = mock ? mockBagsIndex[aux] : Int(arc4random_uniform(UInt32(emptyIndex.count)))
            let index = emptyIndex.remove(at: pos).index
            if matriz[index.col][index.row].type != .Empty { continue }

            bags.data[aux].index = index
            addSlot(index, type: .saco)
            aux += 1
        }
        
        print("\(#function) - completo")
    }
}
