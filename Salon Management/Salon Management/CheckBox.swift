//
//  Checkbox.swift
//  Salon Management
//
//  Created by Cory Edwards on 7/21/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    
    //MARK: Properties
    let checkedImage = UIImage(named: "checkedImage")
    let uncheckedImage = UIImage(named: "uncheckedImage")
    
    var isChecked : Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            }
            else {
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
