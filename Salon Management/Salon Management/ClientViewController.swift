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
    UINavigationControllerDelegate{
    
    //MARK: Properties
    @IBOutlet weak var saveButton: UIButton!
    
    
    //Either made by being passed in, or constructed in prepare()
    var client: Client?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            fatalError("The ClientViewController is not inside a navigation controller.")
        }
    }
    
    
    //This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        //let name = nameTextField.text ?? ""
        
        //Set the meal to be passed to MealTableViewController after the unwind segue.
        //client = Client(name: name, photo: photo, rating: rating)
    }
 

}
