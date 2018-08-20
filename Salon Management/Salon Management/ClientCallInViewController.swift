//
//  ClientViewController.swift
//  Salon Management
//
//  Created by Cory Edwards on 7/19/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit
import os.log

class ClientCallInViewController: UIViewController, UITextFieldDelegate,
UINavigationControllerDelegate, UICollectionViewDataSource{
    
    //MARK: Properties
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var itemSelectList: UICollectionView!
    @IBOutlet weak var timeTextField: UITextField!
    
    //Possible options for the user to select.
    var possibleItems: [String] = ["Manicure", "Manicure Shellac", "Ombré", "Pedicure", "Pedicure Shellac", "Fill", "Combo", "Fullset", "Dip Powder", "Polish Change"]
    
    
    //Either made by being passed in, or constructed in prepare()
    var client: Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        itemSelectList.dataSource = self
        nameTextField.delegate = self
        timeTextField.delegate = self
        
        //Sort the Items
        possibleItems.sort()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        //Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddClientMode = presentingViewController is UINavigationController
        if isPresentingInAddClientMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ClientViewCallInController is not inside a navigation controller.")
        }
    }
    
    
    //This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard (sender as? UIButton) != nil else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let time = timeTextField.text ?? ""
        var items = ""
        
        for i in 0...itemSelectList.numberOfItems(inSection: 0) {
            let cell = itemSelectList.cellForItem(at: IndexPath(item: i, section: 0)) as? ItemSelectCollectionViewCell
            if let checked = cell?.checkbox.isChecked, let itemName = cell?.itemNameLabel.text, checked {
                if items.isEmpty {
                    items += itemName
                }
                else {
                    items += ", " + itemName
                }
            }
        }
        
        //Set the meal to be passed to MealTableViewController after the unwind segue.
        client = Client(name: name, items: items, employee: nil, timeIn: time, timeBack: nil)
    }
    
    
    //MARK: UICollectionViewDatasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return possibleItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemSelectCollectionViewCell", for: indexPath) as? ItemSelectCollectionViewCell else {
            fatalError("dequeued cell is not of ItemSelectCollectionViewCell.")
        }
        
        let item = possibleItems[indexPath.row]
        
        // Configure the cell
        cell.itemNameLabel.text = item
        
        return cell
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

