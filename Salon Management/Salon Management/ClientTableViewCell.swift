//
//  ClientTableViewCell.swift
//  Salon Management
//
//  Created by Cory Edwards on 7/19/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell, UICollectionViewDataSource {
    
    
    //MARK: Properties
    @IBOutlet weak var clientNameLabel: UILabel!
    @IBOutlet weak var signInTimeLabel: UILabel!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var timeBackLabel: UILabel!
    @IBOutlet weak var clientNumberLabel: UILabel!
    
    var items = [String]()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: Extra
    func updateView() {
        //Needs to force the collection view to update with new items.
    }
    
    //MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? ItemCollectionViewCell else {
            fatalError("dequeued cell is not of ItemCollectionViewCell.")
        }
        
        let item = items[indexPath.row]
        
        // Configure the cell
        cell.itemNameLabel.text = item
        
        return cell
    }

}
