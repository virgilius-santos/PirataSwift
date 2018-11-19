//
//  SlotView.swift
//  Pirata
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

extension UIView {

    func fadeOut(speed: Double, completion: @escaping()->()) {
        UIView.animate(withDuration: speed, animations: {
            self.frame.size = .zero
        }) { [weak self] (check) in
            if self != nil {
                completion()
            }
        }
    }

    func growUp(speed: Double, completion: @escaping()->()) {
        UIView.animate(withDuration: speed, animations: { [weak self] in
            self?.frame.size.height *= 1.2
            self?.frame.size.width *= 1.2
        }) { [weak self] (check) in
            UIView.animate(withDuration: speed, animations: { [weak self] in
                self?.frame.size.height *= 0.8
                self?.frame.size.width *= 0.8
            }) { [weak self] (check) in
                if self != nil {
                    completion()
                }
            }
        }
    }

    func flip(speed: Double) {
        let transitionOptions: UIView.AnimationOptions = [.repeat, .transitionFlipFromRight, .showHideTransitionViews]

        UIView.transition(with: self, duration: speed, options: transitionOptions, animations: { [weak self] in
            self?.isHidden = false
        }) { [weak self] (check) in
            self?.isHidden = false
        }
    }

    func goOut(direction: Orientation, value: CGFloat, speed: Double, completion: @escaping()->()) {
        UIView.animate(withDuration: speed, animations: { [weak self] in
            if direction == .vertical {
                self?.center.x += value
            } else {
                self?.center.y += value
            }
        }) { (_) in
            completion()
        }
    }

    func moveAnimation(center: CGPoint, speed: Double, completion: @escaping()->()) {
        UIView.animate(withDuration: speed, animations: {
            self.center = center
        }) { _ in completion() }
    }
    
}
