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
        while true {
            if case .finished = currentEvent {
                break
            }
            if case .error = currentEvent {
                break
            }

            switch currentEvent {
            case .start:
                redeNeural.setPesos()
                currentEvent = .analisarPosicaoAtual
                break
            case .analisarPosicaoAtual:
                analisePosicaoAtual()
                break
            case .analisarRegiao:
                analiseRegion()
                break
            case .analisar(let (slot, movement)):
                analisarMovimentoEscolhido(slot: slot, movement: movement)
                break
            case .goToSlot(let movement):
                move(movement: movement)
                currentEvent = .analisarPosicaoAtual
                break
            case .error:
                print("\n--------Erroor--------\n")
                break
            default:
                break
            }
        }
    }

    func analisePosicaoAtual() {
        let position = agentMap.getSlot(fromIndex: location.index)
        switch position.type {
        case .muro:
            agentData.points += Pontuacao.muro
            currentEvent = .finished
            break
        case .buraco:
            agentData.points += Pontuacao.buraco
            currentEvent = .finished
            break
        case .saco:
            colectBag(slot: location)
            currentEvent = .analisarRegiao
            agentData.points += Pontuacao.saco
            break
        case .porta:
            agentData.points += Pontuacao.porta
            currentEvent = .completed
            break
        default: //todos os outros são "empty"
            agentData.points += Pontuacao.empty
            currentEvent = .analisarRegiao
            break
        }
    }

    func analiseRegion() {
        let regionList = agentMap.getRegion(fromLocation: location)
        guard let movement = redeNeural.entrada(slots: regionList) else {
            return
        }

        var rowOffset = 0
        var cowOffset = 0

        switch movement.direcao {
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

        currentEvent = .analisar(slot!, movement)
    }

    func analisarMovimentoEscolhido(slot: Slot, movement: Movement) {
        switch slot.type {
        case .muro:
            wrongMove(movement: movement)
            agentData.points += Pontuacao.buraco
            currentEvent = .finished
            break
        case .buraco where movement.acao == .anda:
            wrongMove(movement: movement)
            agentData.points += Pontuacao.buraco
            currentEvent = .finished
            break
        case .buraco where movement.acao == .pula:
            agentData.points += Pontuacao.pulaBuraco
            currentEvent = .goToSlot(movement)
            break
        default:
            currentEvent = .goToSlot(movement)
            break
        }
    }

    func move(movement: Movement) {
        guard let newSlot = agentMap.getSlot(fromIndex: location.index, withMovement: movement) else {
            return
        }

        location = newSlot
        if movement.acao == .anda {
            moveView(to: newSlot)
        } else {
            jumpView(to: newSlot)
        }
    }

    func wrongMove(movement: Movement) {
        guard let newSlot = agentMap.getSlot(fromIndex: location.index, withMovement: movement) else {
            return
        }

        location = newSlot
        if movement.acao == .anda {
            moveView(to: newSlot)
        } else {
            jumpView(to: newSlot)
        }

    }
}

