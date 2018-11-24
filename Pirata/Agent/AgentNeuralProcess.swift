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
        while !stopped {
            switch currentEvent! {
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
                break
            case .finished:
                stopped = true
                break
            case .error:
                print("\n--------Erroor--------\n")
                break
            }
        }
    }

    func analisePosicaoAtual() {
        let position = mapSlot()
        switch position.type {
        case .muro:
            faults += 100
            currentEvent = .finished
            break
        case .saco:
            colectBag(slot: location)
            break
        case .porta:
            isCompleted = true
            currentEvent = .finished
            break
        case .buraco:
            faults += 50
            currentEvent = .finished
            break
        default: //todos os outros são "empty"
            currentEvent = .analisarRegiao
            break
        }
    }

    func analiseRegion() {
        let regionList = getRegion()
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
        case .muro where movement.acao == .pula:
            wrongMove(movement: movement)
            faults += 100
            currentEvent = .finished
            break
        case .buraco where movement.acao == .pula:
            holeJumpeds += 1
            currentEvent = .goToSlot(movement)
            break
        default: //todos os outros são "empty"
            currentEvent = .goToSlot(movement)
            break
        }
    }

    func colectBag(slot: Slot) {

        let bag = self.coletarBag(slot)
        bags.append(bag)
        currentEvent = .analisarRegiao

    }

    func move(movement: Movement) {
        let newSlot = slot(movement: movement)!

        location = newSlot
        if movement.acao == .anda {
            moveView(to: newSlot)
        } else {
            jumpView(to: newSlot)
        }

       currentEvent = .analisarPosicaoAtual
    }

    func wrongMove(movement: Movement) {
        guard let newSlot = slot(movement: movement) else {
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
