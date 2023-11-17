//
//  Extensions.swift
//  Chess Clock
//
//  Created by Sanchez on 23.06.2023.
//

import Foundation
import UIKit

extension UILabel {
    func softAppearance(duration: TimeInterval = 0.2, text: String) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {
            self.text = text
        },  completion: nil)
    }
    
    func animateLabelPulse() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
            self.alpha = 0.5
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform.identity
                self.alpha = 1.0
            }
        }
    }
    
    func animateColorChangingLabelText(to color: UIColor, duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.textColor = color
        }, completion: { _ in
            completion?()
        })
    }
}

extension Int {
    func toString() -> String {
        return String(self)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alfa: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alfa
        )
    }
}


extension UIView {
    func animateColorChangingView(to color: UIColor, duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.backgroundColor = color
        }, completion: { _ in
            completion?()
        })
    }
}

extension UIButton {
    func animateColorChangingButton(to color: UIColor, duration: TimeInterval = 0.5, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.tintColor = color
        }, completion: { _ in
            completion?()
        })
    }
}

