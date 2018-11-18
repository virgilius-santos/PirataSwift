//
//  MapView.swift
//  Pirata
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class MapViewController {

    private var _mapModel: Map

    private weak var _rootStackView: UIStackView?

    private var _matrizSlotView: [[SlotView]]

    init(map: Map) {
        _matrizSlotView = []
        _mapModel = map

        completeMatriz()
    }

    /// converte os modelos de slot presentes no _mapModel
    /// em slotView que serão add na tela
    private func completeMatriz() {
        _matrizSlotView
            = _mapModel
                .matriz
                .lazy
                .map { (slots) -> [SlotView] in

                    return slots.map({$0.slotView()})
        }

    }

    /// converte os slotViews em Stacks que serão vinculadas
    /// ao rootStack
    func addStackViews(rootStackView: UIStackView) {
        _matrizSlotView.forEach { (slots) in
            let stack = slots.stackView()
            rootStackView.addArrangedSubview(stack)
        }
        _rootStackView = rootStackView
    }

    /// le todas as imagens que foram setadas no modelo
    func loadData(completion: @escaping()->()) {
        _mapModel.loadData() { matriz in
            matriz
                .lazy
                .flatMap({$0})
                .forEach { (slot) in
                    let slotView = slot.slotView(fromMatriz: self._matrizSlotView)
                    slotView.imageView.image = slot.type.image
            }
            completion()
        }
    }

    /// some com um slot
    func fadeOut(slot: Slot, speed: Double, completion: @escaping()->()) {
        let slotView = slot.slotView(fromMatriz: _matrizSlotView)
        slotView.imageView.fadeOut(speed: speed, completion: completion)
    }

    /// faz um slot crescer
    func growUp(slot: Slot, speed: Double) {
        let slotView = slot.slotView(fromMatriz: _matrizSlotView)
        slotView.imageView.growUp(speed: speed)
    }
    
    func frame(fromSlot slot: Slot) -> CGRect {
        let slotView = slot.slotView(fromMatriz: _matrizSlotView)
        return slotView.imageView.frame
    }

    func center(fromSlot slot: Slot, to view: UIView) -> CGPoint {
        let slotView = slot.slotView(fromMatriz: _matrizSlotView)
        return view.convert(slotView.center, from: slotView.superview)
    }

}
