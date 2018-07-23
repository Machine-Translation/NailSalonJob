//
//  ClientTableViewCell.swift
//  Salon Management
//
//  Created by Cory Edwards on 7/19/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {
    
    
    //MARK: Properties
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var signInTimeLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var timeBackLabel: UILabel!
    @IBOutlet weak var clientNumberLabel: UILabel!
    @IBOutlet weak var itemCollectionLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
