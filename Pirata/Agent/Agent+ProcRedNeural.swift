//
//  AgentNeuralProcess.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Agent {

    func switchEvent() {
        mainLoop: while true {

            switch eventoAtual {
            case .comecar(let weights):
                neuralNet.setWeights(weights)
                eventoAtual = .analisarPosicaoAtual
                break
            case .analisarPosicaoAtual:
                analisePosicaoAtual()
                break
            case .analisarRegiao:
                analiseRegiaoParaProximoMovimento()
                break
            case .analisarMovimento(let (slot, movement)):
                analisarMovimentoEscolhido(slot: slot, movement: movement)
                break
            case .irParaSlot(let movement):
                move(movement: movement)
                eventoAtual = .analisarPosicaoAtual
                break
            case .completar:
                updateValues()
                break mainLoop
            case .erro:
                print("\n--------Erroor--------\n")
                break mainLoop
            default:
                break mainLoop
            }
        }
    }

    func analisePosicaoAtual() {
        let position = agentMap.getSlot(fromIndex: location.index)
        switch position.type {
        case .wall:
            agentData.points += Point.wall
            eventoAtual = .terminar
            break
        case .hole:
            agentData.points += Point.hole
            eventoAtual = .terminar
            break
        case .bag:
            colectBag(slot: location)
            eventoAtual = .analisarRegiao
            agentData.points += Point.bag
            break
        case .door:
            agentData.points += Point.door
            eventoAtual = .completar
            break
        default: //todos os outros são "empty"
            agentData.points += Point.empty
            eventoAtual = .analisarRegiao
            break
        }
    }

    func analiseRegiaoParaProximoMovimento() {

        let regionList = agentMap.getRegion(fromLocation: location)

        guard let movement = neuralNet.getMovement(fromSlots: regionList) else {
            return
        }

        let slot = getSlot(fromRegion: regionList, fromMovement: movement)

        eventoAtual = .analisarMovimento(slot, movement)
    }

    func analisarMovimentoEscolhido(slot: Slot, movement: Movement) {
        switch slot.type {
        case .wall:
            move(movement: movement)
            agentData.points += Point.hole
            eventoAtual = .terminar
            break
        case .hole where movement.action == .walk:
            move(movement: movement)
            agentData.points += Point.hole
            eventoAtual = .terminar
            break
        case .hole where movement.action == .jump:
            agentData.points += Point.jumpHole
            eventoAtual = .irParaSlot(movement)
            break
        default:
            eventoAtual = .irParaSlot(movement)
            break
        }
    }

    func move(movement: Movement) {
        guard let newSlot = agentMap.getSlot(fromIndex: location.index, withMovement: movement) else {
            return
        }

        location = newSlot

        switch movement.action {
        case .walk:
            moveView(to: newSlot)
        case .jump:
            jumpView(to: newSlot)
        }
    }

    func getSlot(fromRegion regionList: Map.RegionList,
                 fromMovement movement: Movement) -> Slot {

        var rowOffset = 0
        var cowOffset = 0

        switch movement.direction {
        case .left: cowOffset = -1
        case .right: cowOffset = 1
        case .up: rowOffset = -1
        case .down: rowOffset = 1
        }

        let checkIndex = Index(col: location.index.col + cowOffset,
                               row: location.index.row + rowOffset)

        let slot = regionList.first(where: {
            $0.index == checkIndex
        })

        return slot!
    }

}

