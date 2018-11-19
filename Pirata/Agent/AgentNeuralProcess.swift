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
            switchEvent(evt: .analisarRegiao)
            break
        case .analisarRegiao:
            analiseRegion()
            break
        case .analisar(let (slot, movement)):
            analisar(slot: slot, movement: movement)
            break
        case .goToSlot(let movement):
            move(movement: movement)
            break
        case .error:
            print("\n--------Erroor--------\n")
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

    func analisar(slot: Slot, movement: Movement) {
        switch slot.type {
        case .muro:
            faults += 100
            stopped = true
            redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
            next()
            break
        case .saco:
            colectBag()
            break
        case .porta:
            isCompleted = true
            stopped = true
            break
        case .buraco where movement.acao == .anda:
            faults += 50
            stopped = true
            redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
            next()
            break
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
        if slot.index != location.index {
            return
        }
        coletarBag(location) { (bag) in
            self.bags.append(bag)
            self.switchEvent(evt: .analisarRegiao)
        }
    }
    
    func move(movement: Movement) {
        move(acao: movement.acao, direcao: movement.direcao) { [weak self] (slot) in
            if slot != nil {
                self?.location = slot!
            }
            self?.switchEvent(evt: .analisarRegiao)
        }
    }
}
