//
//  ClientViewController.swift
//  Salon Management
//
//  Created by Cory Edwards on 7/19/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit
import os.log

class ClientViewController: UIViewController, UITextFieldDelegate,
UINavigationControllerDelegate, UICollectionViewDataSource{
    
    //MARK: Properties
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var itemSelectList: UICollectionView!
    
    //Possible options for the user to select.
    var possibleItems: [String] = ["Manicure", "Manicure Shellac", "Ombré", "Pedicure", "Pedicure Shellac", "Fill", "Combo", "Fullset", "Dip Powder", "Polish Change"]
    
    
    //Either made by being passed in, or constructed in prepare()
    var client: Client?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        itemSelectList.dataSource = self
        
        //Sort the Items
        possibleItems.sort()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func unwindToClientSignIn(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ClientCallInViewController {
            client = sourceViewController.client
            if client != nil {
                self.performSegue(withIdentifier: "callSignInProccessed", sender: self)
            }
            else {
                os_log("The client is still nil after submitting.", log: OSLog.default, type: .debug)
            }
        }
        else {
            os_log("The controller is not set up properly.", log: OSLog.default, type: .debug)
        }
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
            fatalError("The ClientViewController is not inside a navigation controller.")
        }
    }
    
    
    //This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if client != nil {
            return
        }
        
        // Configure the destination view controller only when the save button is pressed.
        guard (sender as? UIButton) != nil else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
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
        client = Client(name: name, items: items)
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
}
