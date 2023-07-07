import UIKit

extension Array where Array == [SlotView] {
    func stackView() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: self)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 5
        stack.clipsToBounds = false
        return stack
    }
}

extension Array where Array == [Slot] {

    /// verifica se os slots estao conectados
    func isConnected() -> Bool {
        if isEmpty { return false }
        let indexs = self.map({$0.index})
        return indexs.isConnected()
    }

    /// busca todos os index nao ocupados
    func getEmptyIndex(
        _ indexExcludeds: Set<Pirata.Index> = Set(),
        _ typeExcludeds: [ImageType] = []
    ) -> [Slot] {
        var typeExcludeds = Set<ImageType>(typeExcludeds)
        typeExcludeds.insert(.wall)

        // filtra os slots
        let filtered = self.filter { (slot) -> Bool in
            if indexExcludeds.contains(slot.index) { return false }
            if typeExcludeds.contains(slot.type) { return false }
            return true
        }

        return filtered
    }
}

extension Array where Array == [Pirata.Index] {

    /// verifica se os index estao conectados
    func isConnected() -> Bool {

        var dataList = self
        if dataList.isEmpty { return false }

        var fila = [Pirata.Index]()
        fila.append(dataList.removeFirst())

        while !fila.isEmpty {
            let current = fila.removeFirst()
            if let index = dataList.firstIndex(where: {$0.col == current.col+1 && $0.row == current.row}) {
                let data = dataList.remove(at: index)
                fila.append(data)
            }
            if let index = dataList.firstIndex(where: {$0.col == current.col-1 && $0.row == current.row}) {
                let data = dataList.remove(at: index)
                fila.append(data)
            }
            if let index = dataList.firstIndex(where: {$0.row == current.row+1 && $0.col == current.col}) {
                let data = dataList.remove(at: index)
                fila.append(data)
            }
            if let index = dataList.firstIndex(where: {$0.row == current.row-1 && $0.col == current.col}) {
                let data = dataList.remove(at: index)
                fila.append(data)
            }
        }

        return dataList.isEmpty
    }

}

extension Array where Array == Map.Region {

    /// slot livre aletorio
    var freeSlot: Slot {
        let slots = getEmptyIndex()
        var slot: Slot?
        repeat {
            let index = Int.randomNumber(slots.count)
            slot = slots[index]
        } while (slot == nil || slot!.type != .empty)
        return slot!
    }

    /// slot a esquerda do index
    func leftSlot(fromIndex index: Pirata.Index, offset: Int = 1) -> Slot? {
        if index.col - offset < 0 {
            return nil
        }
        return self[index.col-offset][index.row]
    }

    /// slot a direita do index
    func rightSlot(fromIndex index: Pirata.Index, offset: Int = 1) -> Slot? {
        if index.col + offset >= self.count {
            return nil
        }
        return self[index.col+offset][index.row]
    }

    /// slot acima do index
    func upSlot(fromIndex index: Pirata.Index, offset: Int = 1) -> Slot? {
        if index.row - offset < 0 {
            return nil
        }
        return self[index.col][index.row-offset]
    }

    /// slot abaixo do index
    func downSlot(fromIndex index: Pirata.Index, offset: Int = 1) -> Slot? {
        if index.row + offset >= self[index.col].count {
            return nil
        }
        return self[index.col][index.row+offset]
    }

    /// slot de acordo com o index e o movimento
    func slot(index: Pirata.Index, movement: Agent.Movement) -> Slot? {
        let offset = movement.action == .walk ? 1 : 2
        switch movement.direction {
        case .left:
            return leftSlot(fromIndex: index, offset: offset)
        case .right:
            return rightSlot(fromIndex: index, offset: offset)
        case .up:
            return upSlot(fromIndex: index, offset: offset)
        case .down:
            return downSlot(fromIndex: index, offset: offset)
        case .none:
            return nil
        }
    }

    /// verifica se o index esta livre
    func isIndexIdle(_ index: Pirata.Index?) -> Bool {
        guard let idx = index else { return false }
        return !self[idx.col][idx.row].isBusy
    }

    /// seta um tipo em um slot espeficico
    mutating func setSlot(_ index: Pirata.Index?, type: ImageType) {
        guard let index = index else { return }
        self[index.col][index.row].set(type: type)
        self[index.col][index.row].setBusy()
    }

    func getSlot(_ index: Pirata.Index) -> Slot {
        self[index.col][index.row]
    }

    /// busca todos os index nao ocupados
    func getEmptyIndex(
        _ indexExcludeds: Set<Pirata.Index> = Set(),
        _ typeExcludeds: [ImageType] = []
    ) -> [Slot] {
        // converte a matriz em um array
        flatMap({$0})
            // filtra os slots
            .getEmptyIndex(indexExcludeds, typeExcludeds)
    }

}
