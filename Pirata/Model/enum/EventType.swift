//
//  EventType.swift
//  Pirata
//
//  Created by Virgilius Santos on 09/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

enum EventType {
    case start
    case lookingBags([DataNode], Map.RouteData?)
    case lookingCheastAndDoors([DataNode], Map.RouteData?)
    case goToRoute(Map.RouteData)
    case goToSlot(Slot, Bool)
    case colectBag
    case traveling(Map.RouteData)
    case randomBags([DataNode])
    case completed
    case distributedBags
}

enum EventNeuralType {
    case comecar
    case analisarPosicaoAtual
    case analisarRegiao
    case analisarMovimento(Slot, Agent.Movement)
    case irParaSlot(Agent.Movement)
    case terminar
    case completar
    case erro
}
