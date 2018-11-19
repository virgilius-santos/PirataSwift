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
            analiseRegion()
            break
        case .goToSlot(let (acao, direcao)):
            move(acao: acao, direcao: direcao)
            break
        case .analisar(let slot):
            analisar(slot: slot)
            break
        case .error:
            print("\n--------Erroor--------\n")
            break
        }
    }

    func analiseRegion() {
        let regionList = getRegion()
        let (acao, direcao) = redeNeural.entrada(slots: regionList)
        switchEvent(evt: .goToSlot(acao, direcao))
    }

    func analisar(slot: Slot) {
        switch slot.type {
        case .muro:
            break
        case .saco:
            break
        case .porta:
            break
        case .buraco:
            break
        default: //todos os outros são "empty"
            break
        }
    }
}
