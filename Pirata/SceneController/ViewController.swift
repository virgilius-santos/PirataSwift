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
        configurator.next()
    }

    func update(coins: Int = 0, general: Int = 0) {
        coinsLabel.text = "Moedas Coletadas: \(coins)"
        totalLabel.text = "Pontuação Geral: \(general)"
    }

    func bauLocalizado(qtd: Int = 0) {
        qtdBauLabel.text = "\(qtd) bau(s)"
    }

    func portaLocalizada(_ status: Bool = false) {
        doorLocLabel.text = status ? "Sim" : "Não"
    }

    func divisaoDeSacolas(_ div: String = String()) {
        divisaoSacolas.text = div
    }

    func growUp(_ slot: Slot) {
        MapVC.growUp(slot: slot, speed: 0.2)
    }

    func getBag(slot: Slot, speed: Double, completion: @escaping(Bag)->()) {
        MapVC.getBag(slot: slot, speed: speed, completion: completion)
    }
}

//extension ViewController: MapDelegate {


//    func createAgent() {
//        let agent = Agent(map: map, startLocation: map.freeSlot)
//        agent.delegate = self
//
//        let agentSlot = agent.location
//
//        let agentImageView = UIImageView(image: agentSlot.type.image)
//        agentImageView.bounds = MapVC.frame(fromSlot: agentSlot)
//        agentImageView.contentMode = .scaleAspectFit
//        view.addSubview(agentImageView)
//
//        agentImageView.center = MapVC.center(fromSlot: agentSlot, to: view)
//
//        self.agent = agent
//        self.agentImageView = agentImageView
//        print("\(#function)\n -\(agentSlot)\n")
//    }

//    func moveAnimation(to: Slot, completion: @escaping()->()) {
////        let center = MapVC.center(fromSlot: to, to: view)
////        UIView.animate(withDuration: speed, animations: {
////            self.agentImageView.center = center
////        }) { (check) in
////            completion()
////        }
//    }
//
//    func jumpAnimation(to: Slot, completion: @escaping()->()) {
////        let center = MapVC.center(fromSlot: to, to: view)
////        UIView.animate(withDuration: speed/2, animations: {
////            self.agentImageView.center = center
////        }) { (check) in
////           completion()
////        }
//    }

//    func loadComplete() {
////        print("\(#function)")
//        MapVC.loadData()
////        createAgent()
//    }
//
//    func setImage(with type: ImageType, index: Index) {
////        let slotView = index.slotView(fromMatriz: MapVC.MatrizSlotView)
////        slotView.imageView.image = type.image
//    }
//
//    func fadeOut(slot: Slot, speed: Double, completion: @escaping()->()) {
////        let view = slot.slotView(fromMatriz: MapVC.MatrizSlotView)
////        fadeOut(view, completion: completion)
//    }

//    func move(to: Slot, completion: @escaping()->()) {
////        moveAnimation(to: to, completion: completion)
//    }
//
//    func jump(to: Slot, completion: @escaping()->()) {
////        jumpAnimation(to: to, completion: completion)
//    }
//
//    func startflip() {
//        agentImageView.flip(speed: speed*2)
//    }
//
//    func stopflip(completion: @escaping()->()) {
//        agentImageView.layer.removeAllAnimations()
//        completion()
//    }
//
//    func goOut(direction: Direction, value: Float) {
//        agentImageView.goOut(direction: direction, value: CGFloat(value), speed: speed)
//    }

//}
