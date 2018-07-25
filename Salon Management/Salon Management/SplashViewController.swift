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
    
    //MARK: Properties
    var todayFolder: URL?
    
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
                    if todayFolder != nil {
                        
                        //Create the destination url for the text file to be saved.
                        let fileUrl = todayFolder!.appendingPathComponent("client list2.txt")//.appendingPathExtension("txt")
                        
                        //Set up the text
                        var text = ""
                        
                        //The header of the file to show the layout.
                        text += "Client name\tTime signed in\r\n"
                        text += "List of items that that the client wanted that is comma delimeted\r\n"
                        text += "Employee who took client\tTime client was taken back\r\n"
                        text += "\r\n"
                        
                        for client in vc.clients {
                            text += String(describing: client) + "\r\n"
                        }
                        
                        //Try to write to disk
                        try text.write(to: fileUrl, atomically: true, encoding: .utf8)
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
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Set up the timestamp
        let now = Date()
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "dd-MM-yyyy"
        
        //Get the root project folder.
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            todayFolder = documentDirectory.appendingPathComponent("\(formatter.string(from: now))")
            do {
                try FileManager.default.createDirectory(atPath: todayFolder!.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch {
                fatalError("Could not create date folder.")
            }
        }
    }
    

}
