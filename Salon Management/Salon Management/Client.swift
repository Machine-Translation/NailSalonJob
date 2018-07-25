//
//  Client.swift
//  Salon Management
//
//  Created by Cory Edwards on 7/19/18.
//  Copyright © 2018 Machine Translation. All rights reserved.
//

import UIKit
import os.log

class Client: NSObject, NSCoding {

    //MARK: Properties
    var name: String
    var employee: String?
    var timeIn: String
    var timeBack: String?
    var items: String
    
    override var description: String {
        // "\t" inserts a tab into the String.
        // "\n" is for IOS new line, but "\r\n" is universal (including windows) new line.
        let line1 = name + "\t" + timeIn + "\r\n"
        let line2 = items + "\r\n"
        var line3 = ""
        
        //Both will either have a value or be nil together, so check both together. If they are nil then skip this line.
        if employee != nil && timeBack != nil {
            line3 = employee! + "\t" + timeBack! + "\r\n"
        }
        
        return line1 + line2 + line3
    }
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("clients")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let employee = "employee"
        static let timeIn = "timeIn"
        static let timeBack = "timeBack"
        static let items = "items"
    }
    
    //MARK: Initialization
    init?(name: String, items: String, employee: String?, timeIn: String, timeBack: String?) {
        
        //The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        //The items list cannot be empty.
        guard !items.isEmpty else {
            return nil
        }
        
        //The timeIn cannot be empty
        guard !timeIn.isEmpty else {
            return nil
        }
        
        self.name = name
        self.items = items
        self.timeIn = timeIn
        self.employee = employee
        self.timeBack = timeBack
    }
    
    
    convenience init?(name: String, items: String) {
        //The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        //The items list cannot be empty.
        guard !items.isEmpty else {
            return nil
        }
        
        //Set up the timestamp
        let now = Date()
        let formatter = DateFormatter()
        
        formatter.timeZone = TimeZone.current
        
        formatter.dateFormat = "HH:mm"
        
        self.init(name: name, items: items, employee: nil, timeIn: formatter.string(from: now), timeBack: nil)
    }
    
    //MARKL NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(employee, forKey: PropertyKey.employee)
        aCoder.encode(timeIn, forKey: PropertyKey.timeIn)
        aCoder.encode(timeBack, forKey: PropertyKey.timeBack)
        aCoder.encode(items, forKey: PropertyKey.items)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        //The name is required. If we cannot decode a name string, the initialization should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a client.", log: OSLog.default, type: .debug)
            return nil
        }
        
        //Employee is optional, so we can use a conditional case.
        let employee = aDecoder.decodeObject(forKey: PropertyKey.employee) as? String
        
        //We must have the timeIn since that is set when the client signs in.
        guard let timeIn = aDecoder.decodeObject(forKey: PropertyKey.timeIn) as? String else {
            os_log("UNabled to decode the timeIn for a client", log: OSLog.default, type: .debug)
            return nil
        }
        
        //TimeBack is set up later, so it is optional.
        let timeBack = aDecoder.decodeObject(forKey: PropertyKey.timeBack) as? String
        
        //Items are important, and are requrired.
        guard let items = aDecoder.decodeObject(forKey: PropertyKey.items) as? String else {
            os_log("Unable to decode items variable for client.", log: OSLog.default, type: .debug)
            return nil
        }
        
        self.init(name: name, items: items, employee: employee, timeIn: timeIn, timeBack: timeBack)
    }
}
