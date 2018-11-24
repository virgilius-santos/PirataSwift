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
        rootStackView.spacing = 5
        MapVC.loadData() {
            self.MapVC.addStackViews(rootStackView: self.rootStackView)
            self.view.layoutIfNeeded()
            self.AgentVC.insertAgent(inView: self.view)
        }
    }
    

    
}

extension ViewController: AgentDelegateInfo {
    

    func next() {
//        animations.append(.void({
            self.configurator.next()
//            self.animations.processAnimation()
//        }))
    }

    func update(coins: Int = 0, general: Int = 0, geracoes: Int) {
        DispatchQueue.main.async {
            self.coinsLabel.text = "Moedas Coletadas: \(coins)"
            self.totalLabel.text = "Pontuação Geral: \(general)"
            self.geracoesLabel.text = "Numero de Geraçoes: \(geracoes)"

        }
    }

    func bauLocalizado(qtd: Int = 0) {
        DispatchQueue.main.async {
            self.qtdBauLabel.text = "\(qtd) bau(s)"
        }
    }

    func portaLocalizada(_ status: Bool = false) {
        DispatchQueue.main.async {
            self.doorLocLabel.text = status ? "Sim" : "Não"
        }
    }

    func divisaoDeSacolas(_ div: String = String()) {
        DispatchQueue.main.async {
            self.divisaoSacolas.text = div
        }
    }
}

