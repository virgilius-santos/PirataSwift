//
//  AgentNeuralProcess.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Agent {

    func switchEvent(evt: EventNeuralType) {
        switch evt {
        case .start:
            redeNeural.setPesos()
            switchEvent(evt: .analisarPosicaoAtual)
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
        case .error:
            print("\n--------Erroor--------\n")
            break
        }
    }

    func analisePosicaoAtual() {
        switch location.type {
        case .muro:
            faults += 100
            stopped = true
            redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
            next()
            break
        case .saco:
            colectBag(slot: location)
            break
        case .porta:
            isCompleted = true
            stopped = true
            redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
            break
        case .buraco:
            faults += 50
            stopped = true
            redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
            next()
            break
        default: //todos os outros são "empty"
            switchEvent(evt: .analisarRegiao)
            break
        }
    }

    func analiseRegion() {
        let regionList = getRegion()
        let movement = redeNeural.entrada(slots: regionList)

        var rowOffset = 0
        var cowOffset = 0

        switch movement.direcao {
        case .left: cowOffset = -1
        case .right: cowOffset = 1
        case .up: rowOffset = -1
        case .down: rowOffset = 1
        }

        let slot = regionList.first(where: {
            $0.index.col == location.index.col + cowOffset
                && $0.index.row == location.index.row + rowOffset
        })!

        switchEvent(evt: .analisar(slot, movement))
    }

    func analisarMovimentoEscolhido(slot: Slot, movement: Movement) {
        switch slot.type {
        case .muro where movement.acao == .pula:
            wrongMove(movement: movement)
//            faults += 100
//            stopped = true
//            redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
//            next()
            break
//        case .buraco where movement.acao == .anda:
//            faults += 50
//            stopped = true
//            redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
//            next()
//            break
        case .buraco where movement.acao == .pula:
            holeJumpeds += 1
            switchEvent(evt: .goToSlot(movement))
            break
        default: //todos os outros são "empty"
            switchEvent(evt: .goToSlot(movement))
            break
        }
    }

    func colectBag(slot: Slot) {

        self.coletarBag(slot) { [weak self] (bag) in
            self?.bags.append(bag)
            self?.switchEvent(evt: .analisarRegiao)
        }

    }

    func move(movement: Movement) {
        move(acao: movement.acao, direcao: movement.direcao) { [weak self] (slot) in
            if slot != nil {
                self?.location = slot!
            }
            self?.switchEvent(evt: .analisarPosicaoAtual)
        }
    }

    func wrongMove(movement: Movement) {
        move(acao: movement.acao, direcao: movement.direcao) { (slot) in
            if slot != nil {
                self.location = slot!
            }
            self.faults += 100
            self.stopped = true
            self.redeNeural.genetic.setarAptidoes(apt: Double(self.totalPoints))
            self.next()
        }
    }
}
