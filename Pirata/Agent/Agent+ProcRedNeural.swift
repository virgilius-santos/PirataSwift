//
//  AgentNeuralProcess.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct Pontuacao {
    init() {}
    static let muro = -100
    static let buraco = -50
    static let pulaBuraco = 60
    static let empty = 20
    static let saco = 80
    static let porta = 120
}

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
            case .finished:
                break
            case .error:
                print("\n--------Erroor--------\n")
                break
            }
        }
    }

    func analisePosicaoAtual() {
        let position = agentMap.getSlot(fromIndex: location.index)
        switch position.type {
        case .muro:
            agentData.faults += Pontuacao.muro
            currentEvent = .finished
            break
        case .buraco:
            agentData.faults += Pontuacao.buraco
            currentEvent = .finished
            break
        case .saco:
            colectBag(slot: location)
            currentEvent = .analisarRegiao
            agentData.faults += Pontuacao.saco
            break
        case .porta:
            agentData.faults += Pontuacao.porta
            currentEvent = .finished
            break
        default: //todos os outros são "empty"
            agentData.faults += Pontuacao.empty
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
            agentData.faults += Pontuacao.buraco
            currentEvent = .finished
            break
        case .buraco where movement.acao == .anda:
            wrongMove(movement: movement)
            agentData.faults += Pontuacao.buraco
            currentEvent = .finished
            break
        case .buraco where movement.acao == .pula:
            agentData.faults += Pontuacao.pulaBuraco
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

