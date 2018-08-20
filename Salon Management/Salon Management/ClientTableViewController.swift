//
//  ViewController.swift
//  Salon Management
//
//  Created by Cory Edwards on 7/18/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit
import os.log

class ClientTableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var SingInButton: UIButton!
    var clients = [Client]()
    var deletedClients = [Client]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Use the edit button item provided by the table view controller.
        //navigationItem.leftBarButtonItem = editButtonItem
        
        //Load any saved meals, otherwise load sample data.
        if let savedClients = loadClients() {
            clients += savedClients
        }
        else {
            loadSampleClients()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "client"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ClientTableViewCell else {
            fatalError("The dequeued cell is not an instance of ClientTableViewCell")
        }
        
        //Fetches the appropriate meal for the data source layout.
        let client = clients[indexPath.row]
        
        //Set up needed variables for elements in cell.
        cell.clientNameLabel.text = client.name
        cell.signInTimeLabel.text = client.timeIn
        cell.employeeNameLabel.text = client.employee
        cell.timeBackLabel.text = client.timeBack
        cell.itemCollectionLabel.text = client.items
        cell.clientNumberLabel.text = String(indexPath.row + 1)
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        //if let cell = tableView.cellForRow(at: indexPath) as? ClientTableViewCell {
            //let client = clients[indexPath.row]
            //if (cell.employeeNameLabel.text == nil || cell.employeeNameLabel.text!.isEmpty) && !client.noShow && !client.left {
                return true
            //}
            //else {
            //    return false
            //}
        //}
        //else {
        //    return false
        //}
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if let cell = tableView.cellForRow(at: indexPath) as? ClientTableViewCell {
            let client = clients[indexPath.row]
            
            //Strings that will determine what to show the user if the client has been claimed yet or not.
            var claimActionText = "Client not set up properly"
            var claimMenuText = "Something is wrong"
            var claimBoolean = false
            
            if cell.employeeNameLabel.text == nil || cell.employeeNameLabel.text!.isEmpty {
                claimActionText = "Claim client"
                claimMenuText = "Claim \(cell.clientNameLabel.text ?? "client")"
                claimBoolean = false
            }
            else {
                claimActionText = "Edit employee name"
                claimMenuText = "Old employee name \(cell.employeeNameLabel.text!)"
                claimBoolean = true
            }
            
            //One of the options that appears on the right when swipe left on a cell of the table.
            let claimAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: claimActionText, handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
                
                //The alert that pops up when this this option is selected.
                let claimMenu = UIAlertController(title: claimMenuText, message: "Please enter your name", preferredStyle: .alert)
                
                //A button that confirms the text in the text field.
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (_) in
                    let textField = claimMenu.textFields![0]
                    
                    //Set up the timestamp
                    let now = Date()
                    let formatter = DateFormatter()
                    
                    formatter.timeZone = TimeZone.current
                    formatter.dateFormat = "HH:mm"
                    
                    //Set the employee and time to the cell.
                    cell.employeeNameLabel.text = textField.text
                    if !claimBoolean {
                        cell.timeBackLabel.text = formatter.string(from: now)
                    }
                    
                    //Set the employee and time for the client object.
                    client.employee = textField.text
                    if !claimBoolean {
                        client.timeBack = formatter.string(from: now)
                    }
                })
                
                //A button that cancels the alert.
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                //Add the text field that will collect the employee's name to the alert.
                claimMenu.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Employee name here"
                })
                
                
                //Add the OK and cancel actions to the alert.
                claimMenu.addAction(okAction)
                claimMenu.addAction(cancelAction)
                
                //Present the alert.
                self.present(claimMenu, animated: true, completion: nil)
            })
            
            let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete client", handler: { (action: UITableViewRowAction, indexPath: IndexPath) -> Void in
                let deleteMenu = UIAlertController(title: "Delete \(cell.clientNameLabel.text ?? "client")", message: "Why should the client be removed?", preferredStyle: .alert)
                let noShowAction = UIAlertAction(title: "Did not show", style: UIAlertActionStyle.default, handler: { (_) in
                    client.noShow = true
                    
                    //Remove the cell from the table.
                    //tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.deletedClients += [client]
                    self.clients.remove(at: indexPath.row)
                    tableView.reloadData()
                })
                
                let leftAction = UIAlertAction(title: "Client left", style: UIAlertActionStyle.default, handler: { (_) in
                    client.left = true
                    
                    //Remove the cell from the table.
                    //tableView.deleteRows(at: [indexPath], with: .automatic)
                    self.deletedClients += [client]
                    self.clients.remove(at: indexPath.row)
                    tableView.reloadData()
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                deleteMenu.addAction(noShowAction)
                deleteMenu.addAction(leftAction)
                deleteMenu.addAction(cancelAction)
                
                self.present(deleteMenu, animated: true, completion: nil)
            })
            
            //Client wants the claim button to be green
            claimAction.backgroundColor = UIColor.green
            
            return [claimAction, deleteAction]
        }
        else {
            return nil
        }
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        /*
        if editingStyle == .delete {
            // Delete the row from the data source
            clients.remove(at: indexPath.row)
            saveClients()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        */
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new client.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let clientDetailViewController = segue.destination as? ClientViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedClientCell = sender as? ClientTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedClientCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedClient = clients[indexPath.row]
            clientDetailViewController.client = selectedClient
            
        default:
            fatalError("Unexpected Segue Identifiter: \(String(describing: segue.identifier))")
        }
    }
    
    
    //MARK: Actions
    @IBAction func unwindToClientList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ClientViewController, let client = sourceViewController.client {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing client.
                clients[selectedIndexPath.row] = client
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                //Add a new client.
                let newIndexPath = IndexPath(row: clients.count, section: 0)
                clients.append(client)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            saveClients()
        }
    }
    
    //MARK: Private functions
    private func loadSampleClients() {
        guard let client1 = Client(name: "Steve", items: "Fill") else {
            fatalError("Unable to instantiate client1")
        }
        
        guard let client2 = Client(name: "Michelle", items: "Manicure, Fill, Fullset", employee: "Stella", timeIn: "15:00", timeBack: "17:00") else {
            fatalError("Unable to instantiate client1")
        }
        
        guard let client3 = Client(name: "Kim", items: "Manicure, Fill, Fullset, Combo, Polish change") else {
            fatalError("Unable to instantiate client1")
        }
        
        
        clients += [client1, client2, client3]
    }
    
    private func saveClients() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(clients, toFile: Client.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Clients successfully saved.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Failed to save clints...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadClients() -> [Client]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Client.ArchiveURL.path) as? [Client]
    }

}

