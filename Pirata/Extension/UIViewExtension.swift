import UIKit
import PromiseKit

extension UIView {

    var delay: Double { return 0.08 }

    func fadeOut(speed: Double) -> Guarantee<Bool> {
        let first: Guarantee<Bool> =  UIView.animate(.promise, duration: speed, delay: delay) {
            self.alpha = 0
        }
        return first
    }

    func fadeIn(speed: Double = 0.1) -> Guarantee<Bool> {
        let first: Guarantee<Bool> =  UIView.animate(.promise, duration: speed, delay: delay) {
            self.alpha = 1
        }
        return first
    }

    func growUp(speed: Double) -> Guarantee<Bool> {
        let first: Guarantee<Bool> = UIView.animate(.promise, duration: speed, delay: delay) {
            self.frame.size.height *= 1.2
            self.frame.size.width *= 1.2
            }
        let second: Guarantee<Bool> = first.then {_ in
                UIView.animate(.promise, duration: speed) {
                    self.frame.size.height *= 0.8
                    self.frame.size.width *= 0.8
                }
        }
        return second
    }

    func flip(speed: Double) -> Guarantee<Bool> {
        let transitionOptions: UIView.AnimationOptions = [.repeat, .transitionFlipFromRight, .showHideTransitionViews]

        let first: Guarantee<Bool> = UIView.transition(.promise, with: self, duration: speed, options: transitionOptions) {
            self.isHidden = false
            }
        let second: Guarantee<Bool> = first.then { _ in
                UIView.animate(.promise, duration: speed) {
                    self.isHidden = false
                }
        }
        return second
    }

    func goOut(direction: Orientation, value: CGFloat, speed: Double) -> Guarantee<Bool> {
        let first = UIView.animate(.promise, duration: speed, delay: delay, animations: { [weak self] in
            if direction == .vertical {
                self?.center.x += value
            } else {
                self?.center.y += value
            }
        })
        return first
    }

    func moveAnimation(center: CGPoint, speed: Double) -> Guarantee<Bool> {
        let first = UIView.animate(.promise, duration: speed, delay: delay, animations: {
            self.center = center
        })
        return first
    }
    
}
