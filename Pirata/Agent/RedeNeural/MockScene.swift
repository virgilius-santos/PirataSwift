//
//  MockScene.swift
//  Pirata
//
//  Created by Virgilius Santos on 19/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation


var bate_parede: [Agent.Movement] {
    return [
        (Acao.anda, Direction.left)
    ]
}

var pula_parede: [Agent.Movement] {
    return [
        (Acao.anda, Direction.down),
        (Acao.pula, Direction.down)
    ]
}

var anda_buraco: [Agent.Movement] {
    return [
        (Acao.anda, Direction.down),
        (Acao.anda, Direction.right)
    ]
}

var pula_buraco: [Agent.Movement] {
    return [
        (Acao.anda, Direction.down),
        (Acao.pula, Direction.right)
    ]
}

var pula_saco_bate_parede: [Agent.Movement] {
    return [
        (Acao.anda, Direction.down),
        (Acao.pula, Direction.right),
        (Acao.anda, Direction.down),
        (Acao.pula, Direction.down)
    ]
}

var chega_porta: [Agent.Movement] {
    return [
        (Acao.anda, Direction.down)
        ,(Acao.pula, Direction.right)
        ,(Acao.anda, Direction.down)
        ,(Acao.anda, Direction.down)
        ,(Acao.pula, Direction.left)
        ,(Acao.pula, Direction.down)
        ,(Acao.anda, Direction.right)
        ,(Acao.anda, Direction.right)
        ,(Acao.pula, Direction.down)
        ,(Acao.anda, Direction.left)
    ]
}

var pula_porta: [Agent.Movement] {
    return [
        chega_porta
        , [(Acao.pula, Direction.left)]
        ].flatMap({$0})
}

var completa: [Agent.Movement] {
    return [
        chega_porta
        , [(Acao.anda, Direction.left)]
        ].flatMap({$0})
}

var actions: [Agent.Movement] = {
    return [
//        bate_parede
//        , pula_parede
//        , anda_buraco
//        , pula_saco_bate_parede
//        , pula_porta
//        , completa
        completa
        ]
        .flatMap({$0})
}()

var nextAction: Agent.Movement? {
    if actions.isEmpty {
        return nil
    }
    let action = actions.removeFirst()
    return action
}
