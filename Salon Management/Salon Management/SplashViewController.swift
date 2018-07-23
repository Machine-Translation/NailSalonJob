//
//  SplashViewController.swift
//  Salon Management
//
//  Created by Cory Edwards on 7/23/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit
import os.log

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func unwindToSplashView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ParentTableViewController {
            if let vc = sourceViewController.controller {
                do {
                   //Get documents folder url
                    if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        //Create the destination url for the text file to be saved.
                        let fileUrl = documentDirectory.appendingPathComponent("file.txt")
                        
                        //Set up the text
                        let text = "This is something!!!"
                        
                        //Try to write to disk
                        try text.write(to: fileUrl, atomically: false, encoding: .utf8)
                    }
                }
                catch {
                    fatalError(String(describing: error))
                }
            }
            else {
                os_log("The container controller is not set up properly.", log: OSLog.default, type: .debug)
            }
        }
        else {
            os_log("The controller is not set up properly.", log: OSLog.default, type: .debug)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
