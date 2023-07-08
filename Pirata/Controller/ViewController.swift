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

    weak var agentVC: AgentViewController!

    weak var mapVC: MapViewController!

    weak var configurator: Configurator!

    weak var animations: Animations!
    
    @IBOutlet weak var qtdBauLabel: UILabel!
    
    @IBOutlet weak var doorLocLabel: UILabel!
    
    @IBOutlet weak var coinsLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var testButton: UIButton!

    @IBOutlet weak var divisaoSacolas: UILabel!

    @IBOutlet weak var geracoesLabel: UILabel!

    @IBOutlet weak var rootStackView: UIStackView!

    @IBAction func testAction(_ sender: Any) {
        if playing {
            configurator.reset()
        } else {
            configurator.start()
        }
        playing.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        rootStackView.spacing = 5
//        mapVC.loadData()
//        mapVC.addStackViews(rootStackView: rootStackView)
//        view.layoutIfNeeded()
        agentVC.insertAgent(inView: view)
    }

}

extension ViewController: AgentDelegateInfo {

    func update(coins: Int = 0, general: Int = 0, genesis: Int) {
        DispatchQueue.main.async {
            self.coinsLabel.text = "Moedas Coletadas: \(coins)"
            self.totalLabel.text = "Pontuação Geral: \(general)"
            self.geracoesLabel.text = "Numero de Geraçoes: \(genesis)"

        }
    }

    func locateCheast(qtd: Int = 0) {
        DispatchQueue.main.async {
            self.qtdBauLabel.text = "\(qtd) bau(s)"
        }
    }

    func locateDoor(_ status: Bool = false) {
        DispatchQueue.main.async {
            self.doorLocLabel.text = status ? "Sim" : "Não"
        }
    }
}
