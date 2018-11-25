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
        (Action.walk, Direction.left)
    ]
}

var pula_parede: [Agent.Movement] {
    return [
        (Action.walk, Direction.down),
        (Action.jump, Direction.down)
    ]
}

var anda_buraco: [Agent.Movement] {
    return [
        (Action.walk, Direction.down),
        (Action.walk, Direction.right)
    ]
}

var pula_buraco: [Agent.Movement] {
    return [
        (Action.walk, Direction.down),
        (Action.jump, Direction.right)
    ]
}

var pula_saco_bate_parede: [Agent.Movement] {
    return [
        (Action.walk, Direction.down),
        (Action.jump, Direction.right),
        (Action.walk, Direction.down),
        (Action.jump, Direction.down)
    ]
}

var chega_porta: [Agent.Movement] {
    return [
        (Action.walk, Direction.down),
        (Action.jump, Direction.right),
        (Action.walk, Direction.down),
        (Action.walk, Direction.down),
        (Action.jump, Direction.left),
        (Action.jump, Direction.down),
        (Action.walk, Direction.right),
        (Action.walk, Direction.right),
        (Action.jump, Direction.down),
        (Action.walk, Direction.left)
    ]
}

var pula_porta: [Agent.Movement] {
    return [
        chega_porta,
        [(Action.jump, Direction.left)]
        ].flatMap({$0})
}

var completa: [Agent.Movement] {
    return [
        chega_porta,
        [(Action.walk, Direction.left)]
        ].flatMap({$0})
}

var defaultActions: [Agent.Movement] {
    return [
//        bate_parede,
//        pula_parede,
//        anda_buraco,
         pula_saco_bate_parede,
//        pula_porta,
//        completa,
        completa,
        completa
        //        completa
        ]
        .flatMap({$0})
}
var actions: [Agent.Movement] = defaultActions

var nextAction: Agent.Movement? {
    if actions.isEmpty {
        return nil
    }
    let action = actions.removeFirst()
    return action
}
