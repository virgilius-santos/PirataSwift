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
        case .analisar(let (slot, acao)):
            analisar(slot: slot, acao: acao)
            break
        case .goToSlot(let (acao, direcao)):
            move(acao: acao, direcao: direcao)
            break
        case .error:
            print("\n--------Erroor--------\n")
            break
        }
    }

    func analiseRegion() {
        let regionList = getRegion()
        let (acao, direcao) = redeNeural.entrada(slots: regionList)

        var rowOffset = 0
        var cowOffset = 0

        switch direcao {
        case .left: cowOffset = -1
        case .right: cowOffset = 1
        case .up: rowOffset = -1
        case .down: rowOffset = 1
        }

        let slot = regionList.first(where: {
            $0.index.col == location.index.col + cowOffset
                && $0.index.row == location.index.row + rowOffset
        })!

        switchEvent(evt: .analisar(slot, acao))
    }

    func analisar(slot: Slot, acao: Acao) {
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
        case .buraco:
            faults += 50
            stopped = true
            redeNeural.genetic.setarAptidoes(apt: Double(totalPoints))
            next()
            break
        default: //todos os outros são "empty"
            analiseRegion()
            break
        }
    }

    func move(acao:Acao, direcao: Direction) {
        //        move(acao: acao, direcao: direcao) { [weak self] (slot) in
        //            if slot != nil {
        //                self?.location = slot!
        //                self?.switchEvent(evt: .analisar(slot!))
        //            } else {
        //                self?.switchEvent(evt: .start)
        //            }
        //        }
    }
}
