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
        return false
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            clients.remove(at: indexPath.row)
            saveClients()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
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

