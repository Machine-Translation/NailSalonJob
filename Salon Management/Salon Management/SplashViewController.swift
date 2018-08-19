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
    @IBOutlet weak var openStoreButton: UIButton!
    var printText = ""
    
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
                        let clientUrl = todayFolder!.appendingPathComponent("client list.txt")
                        let deletedClientUrl = todayFolder!.appendingPathComponent("deleted client list.txt")
                        
                        //Set up the text
                        var text = ""
                        
                        //The header of the file to show the layout.
                        text += "Client name\t\t\t\tTime signed in\r\n"
                        text += "List of items that that the client wanted that is comma delimeted\r\n"
                        
                        var clientText = text + "Employee who took client\t\t\t\tTime client was taken back\r\n\r\n"
                        var deletedClientText = text + "Reason why client was deleted\r\n\r\n"
                        
                        for client in vc.clients {
                            clientText += String(describing: client) + "\r\n"
                        }
                        
                        for client in vc.deletedClients {
                            deletedClientText += String(describing: client) + "\r\n"
                        }
                        
                        //Try to write to disk
                        try clientText.write(to: clientUrl, atomically: true, encoding: .utf8)
                        try deletedClientText.write(to: deletedClientUrl, atomically: true, encoding: .utf8)
                        
                        printText = clientText
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
    
    @IBAction func printDay(_ sender: UIButton) {
        if !printText.isEmpty {
            //Try to print the documents
            let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12), NSAttributedStringKey.foregroundColor: UIColor.black]
            let stringToPrint = NSAttributedString(string: printText, attributes: attributes)
            let print = UISimpleTextPrintFormatter(attributedText: stringToPrint)
            let viewController = UIActivityViewController(activityItems: [print], applicationActivities: nil)
            viewController.popoverPresentationController?.sourceView = sender.imageView
            self.present(viewController, animated: true, completion: nil)
        }
        else {
            //The alert that pops up when this this option is selected.
            let noPrintMenue = UIAlertController(title: "Nothing to print", message: "The day has not started, so there is nothing to print", preferredStyle: .actionSheet)
            
            noPrintMenue.popoverPresentationController?.sourceView = sender.imageView
            
            //A button that cancels the alert.
            let cancelAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            noPrintMenue.addAction(cancelAction)
            self.present(noPrintMenue, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        printText = ""
        
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
