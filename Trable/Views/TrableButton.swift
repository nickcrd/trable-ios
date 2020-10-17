//
//  TrableButton.swift
//  Trable
//
//  Created by nc on 19.09.20.
//

import UIKit

@IBDesignable
class TrableButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override open var isHighlighted: Bool {
        didSet {
            if oldValue == false && isHighlighted {
                backgroundColor = backgroundColor?.darker(0.2)
            } else if oldValue == true && !isHighlighted {
                backgroundColor = backgroundColor?.lighter(0.2)
            }
        }
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        
        setTitleColor(titleColor(for: .normal), for: .highlighted)
        
        setShadow()
    }
    
    private func setShadow() {
           layer.shadowColor   = UIColor.black.cgColor
           layer.shadowOffset  = CGSize(width: 0.0, height: 6.0)
           layer.shadowRadius  = 4
           layer.shadowOpacity = 0.1
           layer.masksToBounds = false
    }
    
}
