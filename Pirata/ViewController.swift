//
//  ViewController.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var map = Map(square: 12)
    private var agent: Agent!
    private var agentImageView: UIImageView!
    
    private lazy var matriz: [[SlotView]] = {
        var matriz = [[SlotView]]()
        for col in 0..<map.matriz.count {
            
            var slots = [SlotView]()
            for row in 0..<map.matriz[col].count {
                let slot = SlotView()
                slot.row = row
                slot.col = col
                slots.append(slot)
            }
            
            matriz.append(slots)
        }
        return matriz
    }()
    
    @IBOutlet weak var coinsLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var testButton: UIButton!
    
    @IBAction func testAction(_ sender: Any) {
        agent?.start()
    }
    
    @IBOutlet weak var rootStackView: UIStackView! {
        didSet {
            rootStackView.spacing = 5
            completeMatriz()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        map.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func completeMatriz() {
        matriz.forEach { (slots) in
            let stack = newStackView(views: slots)
            rootStackView.addArrangedSubview(stack)
        }
    }
    
    func newStackView(views: [UIView]) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: views)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 5
        stack.clipsToBounds = false
        return stack
    }
    
    func slotView(_ slot:Slot) -> SlotView {
        return matriz[slot.index.col][slot.index.row]
    }
    
    func center(_ slotView: SlotView) -> CGPoint {
        return view.convert(slotView.center, from: slotView.superview)
    }
    
    func createAgent() {
        let agent = Agent(map: map, startLocation: map.freeSlot)
        agent.delegate = self
        
        let agentSlot = agent.location
        let originView = self.slotView(agentSlot)
        
        let agentImageView = UIImageView(image: agentSlot.type.image)
        agentImageView.bounds = originView.imageView.frame
        agentImageView.contentMode = .scaleAspectFit
        view.addSubview(agentImageView)
        
        agentImageView.center = center(originView)
        
        self.agent = agent
        self.agentImageView = agentImageView
        print("\(#function)\n -\(agentSlot)\n")
    }
    
    let speed: Double = mock ? 0.1 : 0.1
    func moveAnimation(to: Slot, completion: @escaping()->()) {
        let destinationView = slotView(to)
        UIView.animate(withDuration: speed, animations: {
            self.agentImageView.center = self.center(destinationView)
        }) { (check) in
            completion()
        }
    }
    
    func jumpAnimation(to: Slot, completion: @escaping()->()) {
        let destinationView = slotView(to)
        UIView.animate(withDuration: speed/2, animations: {
            self.agentImageView.center = self.center(destinationView)
        }) { (check) in
           completion()
        }
    }
    
    func fadeOut(_ view: SlotView, completion: @escaping()->()) {
        UIView.animate(withDuration: speed, animations: {
            view.imageView.frame.size = .zero
        }) { (check) in
            completion()
        }
    }
    
    func flip(_ view: UIView) {
        let transitionOptions: UIViewAnimationOptions = [.repeat, .transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: view, duration: speed*2, options: transitionOptions, animations: {
            view.isHidden = false
        }) { (check) in
            view.isHidden = false
        }
    }
}

extension ViewController: MapDelegate {
    func loadComplete() {
        print("\(#function)")
        createAgent()
    }
    
    func setImage(with type: ImageType, index: Index) {
        let slot = matriz[index.col][index.row]
        slot.imageView.image = type.image
    }
    
    func fadeOut(slot: Slot, completion: @escaping()->()) {
        let view = slotView(slot)
        fadeOut(view, completion: completion)
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
        flip(agentImageView)
    }
    
    func stopflip(completion: @escaping()->()) {
        agentImageView.layer.removeAllAnimations()
        completion()
    }
}
