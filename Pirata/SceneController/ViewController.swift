//
//  ViewController.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var playing = false

    weak var AgentVC: AgentViewController!

    weak var MapVC: MapViewController!

    weak var configurator: Configurator!

    var autoStart = false

    weak var animations: Animations!
    
    @IBOutlet weak var qtdBauLabel: UILabel!
    
    @IBOutlet weak var doorLocLabel: UILabel!
    
    @IBOutlet weak var coinsLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var testButton: UIButton!
    
    @IBOutlet weak var divisaoSacolas: UILabel!

    @IBOutlet weak var rootStackView: UIStackView!

    @IBAction func testAction(_ sender: Any) {
        if playing {
            AgentVC.Agent.stop()
            configurator.reset()
        } else {
            AgentVC.Agent.start()
        }
        playing.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootStackView.spacing = 5
        MapVC.loadData() {
            self.MapVC.addStackViews(rootStackView: self.rootStackView)
            self.view.layoutIfNeeded()
            self.AgentVC.insertAgent(inView: self.view)
            if self.autoStart {
                self.AgentVC.Agent.start()
            }
        }
    }


}

extension ViewController: AgentDelegate {
    func next() {
        animations.append(.void({
            self.configurator.next()
        }))
    }

    func update(coins: Int = 0, general: Int = 0) {
        animations.append(.void({
            self.coinsLabel.text = "Moedas Coletadas: \(coins)"
            self.totalLabel.text = "Pontuação Geral: \(general)"
        }))
    }

    func bauLocalizado(qtd: Int = 0) {
        animations.append(.void({
            self.qtdBauLabel.text = "\(qtd) bau(s)"
        }))
    }

    func portaLocalizada(_ status: Bool = false) {
        animations.append(.void({
            self.doorLocLabel.text = status ? "Sim" : "Não"
        }))
    }

    func divisaoDeSacolas(_ div: String = String()) {
        animations.append(.void({
            self.divisaoSacolas.text = div
        }))
    }

    func growUp(_ slot: Slot) {
        MapVC.growUp(slot: slot, speed: 0.2)
    }

    func getBag(slot: Slot, speed: Double) -> Bag {
        return MapVC.getBag(slot: slot, speed: speed)
    }
}

