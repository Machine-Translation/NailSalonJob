
//
//  ParentTableViewController.swift
//  Salon Management
//
//  Created by Cory Edwards on 7/23/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit

class ParentTableViewController: UIViewController {
    
    //MARK: Properties
    var controller: ClientTableViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? ClientTableViewController {
            controller = vc
        }
    }
 

}
