//
//  ViewController.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let speed: Double = mock ? 0.1 : 0.1
    private lazy var map = Map(square: (mock ? 10 : 10))
    private var agent: Agent!
    private var agentImageView: UIImageView!

    lazy var MapVC: MapViewController! = MapViewController(map: map)

    @IBOutlet weak var qtdBauLabel: UILabel!
    
    @IBOutlet weak var doorLocLabel: UILabel!
    
    @IBOutlet weak var coinsLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var testButton: UIButton!
    
    @IBAction func testAction(_ sender: Any) {
        agent?.start()
    }
    
    @IBOutlet weak var divisaoSacolas: UILabel!
    
    
    @IBOutlet weak var rootStackView: UIStackView! {
        didSet {
            rootStackView.spacing = 5
            MapVC.addStackViews(rootStackView: rootStackView)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        map.loadData()
    }
    
    func createAgent() {
        let agent = Agent(map: map, startLocation: map.freeSlot)
        agent.delegate = self
        
        let agentSlot = agent.location
        
        let agentImageView = UIImageView(image: agentSlot.type.image)
        agentImageView.bounds = MapVC.frame(fromSlot: agentSlot)
        agentImageView.contentMode = .scaleAspectFit
        view.addSubview(agentImageView)
        
        agentImageView.center = MapVC.center(fromSlot: agentSlot, to: view)
        
        self.agent = agent
        self.agentImageView = agentImageView
        print("\(#function)\n -\(agentSlot)\n")
    }
    
    func moveAnimation(to: Slot, completion: @escaping()->()) {
        let center = MapVC.center(fromSlot: to, to: view)//destinationView = to.slotView(fromMatriz: MapVC.MatrizSlotView)
        UIView.animate(withDuration: speed, animations: {
            self.agentImageView.center = center//self.center(destinationView)
        }) { (check) in
            completion()
        }
    }
    
    func jumpAnimation(to: Slot, completion: @escaping()->()) {
        let center = MapVC.center(fromSlot: to, to: view)//to.slotView(fromMatriz: MapVC.MatrizSlotView)
        UIView.animate(withDuration: speed/2, animations: {
            self.agentImageView.center = center//self.center(destinationView)
        }) { (check) in
           completion()
        }
    }
}

extension ViewController: MapDelegate {
    func loadComplete() {
//        print("\(#function)")
        MapVC.loadData()
        createAgent()
    }
    
    func setImage(with type: ImageType, index: Index) {
//        let slotView = index.slotView(fromMatriz: MapVC.MatrizSlotView)
//        slotView.imageView.image = type.image
    }
    
    func fadeOut(slot: Slot, speed: Double, completion: @escaping()->()) {
//        let view = slot.slotView(fromMatriz: MapVC.MatrizSlotView)
//        fadeOut(view, completion: completion)
    }
}

extension ViewController: AgentDelegate {
    func update(coins: Int, general: Int) {
        coinsLabel.text = "Moedas Coletadas: \(coins)"
        totalLabel.text = "Pontuação Geral: \(general)"
    }
    
    func move(to: Slot, completion: @escaping()->()) {
        moveAnimation(to: to, completion: completion)
    }
    
    func jump(to: Slot, completion: @escaping()->()) {
        jumpAnimation(to: to, completion: completion)
    }
    
    func startflip() {
        agentImageView.flip(speed: speed*2)
    }
    
    func stopflip(completion: @escaping()->()) {
        agentImageView.layer.removeAllAnimations()
        completion()
    }
    
    func goOut(direction: Direction, value: Float) {
        agentImageView.goOut(direction: direction, value: CGFloat(value), speed: speed)
    }
    
    func growUp(_ slot: Slot) {
        MapVC.growUp(slot: slot, speed: speed*2)
    }
    
    func bauLocalizado(qtd: Int) {
        qtdBauLabel.text = "\(qtd) bau(s)"
    }
    
    func portaLocalizada() {
        doorLocLabel.text = "Sim"
    }
    
    func divisaoDeSacolas(_ div: String) {
        divisaoSacolas.text = div
    }
}
