import Foundation

protocol AgentDelegateInfo: AnyObject {
    func update(coins: Int, general: Int, genesis: Int)
    func locateCheast(qtd: Int)
    func locateDoor(_ status: Bool)
}

extension Agent {
    func updateValues() {
        let coins = agentData.totalCoins
        let general = agentData.totalPoints
        let genesis = agentData.genesis
        self.delegate?.update(coins: coins, general: general, genesis: genesis)
    }
    
    func locateCheast() {
        delegate?.locateCheast(qtd: agentData.cheasts.count)
    }
    
    func locateDoor() {
        delegate?.locateDoor(true)
    }
}
