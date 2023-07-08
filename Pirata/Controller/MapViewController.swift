import UIKit
import PromiseKit

final class MapViewController {

    private var _mapModel: Map

    private weak var _rootStackView: UIStackView?

    private var _matrizSlotView: [[SlotView]]

    weak var animations: Animations!

    init(map: Map) {
        _matrizSlotView = []
        _mapModel = map
    }

    func loadData() -> Map.Region {
        _mapModel.fillMatriz()
        return _mapModel.loadData()
    }

    func reloadData() {
        _mapModel.loadData()
            .lazy
            .flatMap({$0})
            .forEach { slot in
                let index = slot.index
                let imgView = self._matrizSlotView[index.col][index.row].imageView
                imgView?.image = slot.type.image
                imgView?.alpha = 1.0
            }
    }

    func restoreData() {
        let views = self._matrizSlotView
            .flatMap({$0})
            .filter({$0.imageType == .bag})

        views.forEach { slotView in
            self.animations.append(.fadeIn(self.appear, (slotView)))
        }

    }

    private func appear(slotView: SlotView) -> Guarantee<Bool> {
        return slotView.imageView.fadeIn()
    }

//    /// converte os modelos de slot presentes no _mapModel
//    /// em slotView que serão add na tela
//    private func completeMatriz(region: Map.Region) {
//        _matrizSlotView = region
//            .lazy
//            .map { (slots) -> [SlotView] in
//                slots.map({$0.slotView()})
//            }
//
//    }

    /// converte os slotViews em Stacks que serão vinculadas
    /// ao rootStack
    func addStackViews(rootStackView: UIStackView) {
        _matrizSlotView.forEach { (slots) in
            let stack = slots.stackView()
            rootStackView.addArrangedSubview(stack)
        }
        _rootStackView = rootStackView
    }
}

extension MapViewController: AgentMapAnimations {
    /// some com um slot
    func getBag(slot: Slot, speed: Double) {
        animations.append(.slotSpeed(getBagAnimation, (slot, speed)))
    }

    /// some com um slot
    private func getBagAnimation(slot: Slot, speed: Double) -> Guarantee<Bool> {
        let slotView = slot.slotView(fromMatriz: _matrizSlotView)
        return slotView.imageView.fadeOut(speed: speed)
    }

    /// faz um slot crescer
    func growUp(slot: Slot, speed: Double) {
        animations.append(.slotSpeed(growUpAnimation, (slot, speed)))
    }

    /// faz um slot crescer
    private func growUpAnimation(slot: Slot, speed: Double) -> Guarantee<Bool> {
        let slotView = slot.slotView(fromMatriz: _matrizSlotView)
        return slotView.imageView.growUp(speed: speed)
    }
}

extension MapViewController: AgentViewControllerDataSource {
    /// retorna o frame de um slot
    func frame(fromSlot slot: Slot) -> CGRect {
        let slotView = slot.slotView(fromMatriz: _matrizSlotView)
        return slotView.imageView.frame
    }

    /// retorna a posicao na tela de um slot em relacao a uma View
    func center(fromSlot slot: Slot, to view: UIView) -> CGPoint {
        let slotView = slot.slotView(fromMatriz: self._matrizSlotView)
        let center: CGPoint = view.convert(slotView.center, from: slotView.superview)
        return center
    }
}
