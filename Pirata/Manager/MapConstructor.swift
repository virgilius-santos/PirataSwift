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
        sideWallPosition = mock ? .left : Position(rawValue: randomNumber(4))
        for aux in 0 ..< mapSettings.square {
            let index = sideWallPosition.sideWall(limit: mapSettings.square, value: aux)
            addSlot(index, type: .muro)
        }
        print("\(#function) - completo")
    }
    
    /// gera a porta que fica no muro lateral
    func makeDoor() {
        // gera o index da porta no paredao
        doorLocation = mock ? 0 : randomNumber(mapSettings.square)
        let index = sideWallPosition.door(limit: mapSettings.square, value: doorLocation)
        addSlot(index, type: .porta)
        print("\(#function) - completo")
    }
    
    /// cria os baus na arena
    func makeCheast() {
        var aux = 0
        // gera os index dos baus
        while (aux < mapSettings.cheastNumbers) {
            let value = mock ? mockCheast[aux] : randomNumber(mapSettings.square)
            if doorLocation == value { continue }
            
            let index = sideWallPosition.cheast(limit: mapSettings.square, value: value)
            if !isIndexIdle(index) { continue }
            
            addSlot(index, type: .bau)
            aux += 1
        }
        print("\(#function) - completo")
    }
    
    /// cria paredes internas
    func makeInternalWall() {
        var index: Index
        var aux = 0
        // gera os index dos baus
        while (aux < mapSettings.internalWallNumbers) {
            
            // seleciona uma direcao aleatoria pra parede interna
            guard let direction = mock ? mockDir[aux] : Direction(rawValue: randomNumber(4))
                else { continue }
            
            // seleciona um ponto que sera a linha ou coluna de acordo com a direcao
            let column = mock ? mockCol[aux] : randomNumber(mapSettings.square)
            let row = mock ? mockRow[aux] : randomNumber(mapSettings.square)

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
    
    /// cria os buracos na arena
    func makeHole() {
        
        var aux = 0
        while (aux < mapSettings.holeNumbers) {
            var emptyIndex = getEmptyIndex(excludeHole: true, excludeCheast: true)
            let pos = mock ? mockHole(emptyIndex,aux: aux) : randomNumber(emptyIndex.count)
            let slot = emptyIndex.remove(at: pos)
            let index = slot.index
            
            // verifica se gerou beco sem saida
            if matriz[index.col][index.row].type != .Empty || !checkMatriz(emptyIndex) {
                emptyIndex.append(slot)
                continue
            }
            
            if (index.col+1<matriz.count && matriz[index.col+1][index.row].type == .buraco)
                || (index.col-1>=0 && matriz[index.col-1][index.row].type == .buraco)
                || (index.row+1<matriz.count && matriz[index.col][index.row+1].type == .buraco)
                || (index.row-1>=0 && matriz[index.col][index.row-1].type == .buraco) {
                emptyIndex.append(slot)
                continue
            }
            
            addSlot(index, type: .buraco)

            aux += 1
        }
        print("\(#function) - completo")
    }
    
    /// coloca os sacos de din din na arena
    func makeBags() {
        var aux = 0
        while aux < bags.data.count {
            var emptyIndex = mock ? mockBags(getEmptyIndex()) : getEmptyIndex()
            let pos = mock ? mockBagsIndex[aux] : randomNumber(emptyIndex.count)
            let index = emptyIndex.remove(at: pos).index
            if matriz[index.col][index.row].type != .Empty { continue }

            bags.data[aux].index = index
            addSlot(index, type: .saco)
            aux += 1
        }
        
        print("\(#function) - completo")
    }
}
