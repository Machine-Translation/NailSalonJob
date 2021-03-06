//
//  GradientButton.swift
//  Salon Management
//
//  Created by Cory Edwards on 8/17/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit

@IBDesignable
class GradientButton: UIButton {


    let gradientLayer = CAGradientLayer()
    
    @IBInspectable
    var topGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor, borderColor: borderColor, borderWidth: borderWidth)
        }
    }
    
    @IBInspectable
    var bottomGradientColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor, borderColor: borderColor, borderWidth: borderWidth)
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor, borderColor: borderColor, borderWidth: borderWidth)
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            setGradient(topGradientColor: topGradientColor, bottomGradientColor: bottomGradientColor, borderColor: borderColor, borderWidth: borderWidth)
        }
    }
    
    //Code from: https://stackoverflow.com/a/48369739
    //Needed to be added because the sides were not being set correctly.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // at this self.view has updated its layout, so now you can update gradientLayer's frame
        gradientLayer.frame = self.bounds
    }
    
    //Code from: https://spin.atomicobject.com/2017/12/14/gradient-uibutton-swift/
    private func setGradient(topGradientColor: UIColor?, bottomGradientColor: UIColor?, borderColor: UIColor?, borderWidth: CGFloat) {
        if let topGradientColor = topGradientColor, let bottomGradientColor = bottomGradientColor, let borderColor = borderColor{
            gradientLayer.colors = [topGradientColor.cgColor, bottomGradientColor.cgColor]
            gradientLayer.borderColor = borderColor.cgColor
            gradientLayer.borderWidth = borderWidth
            gradientLayer.cornerRadius = layer.cornerRadius
            layer.insertSublayer(gradientLayer, at: 0)
        } else {
            gradientLayer.removeFromSuperlayer()
        }
    }
}
