//
//  ListViewController.swift
//  CoreDataDemo
//
//  Created by Mazharul Huq on 2/16/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    var managedContext:NSManagedObjectContext!
    var persons:[NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //1 Create a fetch request
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //2 Provide the fetch request to fetch(_ :) method of managed object context
        do {
            persons = try self.managedContext.fetch(fetchRequest)
            self.tableView.reloadData()
        } catch let error as NSError{
            print("Unable to fetch records from store due to \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let person = persons[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "lastName") as? String
        var firstName = ""
        if let name = person.value(forKey: "firstName") as? String{
            firstName = name
        }
        var dobString = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        if let date = person.value(forKey: "dateOfBirth") as? Date{
            dobString = "  DOB: \(dateFormatter.string(from: date))"
        }
        cell.detailTextLabel?.text = firstName + dobString

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let person = persons[indexPath.row]
            //Deletes an entry from managed object
            self.managedContext.delete(person)
            //Save context
            do {
                try self.managedContext.save()
                persons.remove(at: indexPath.row)//Remove from the array
                self.tableView.reloadData()//Reload table
            } catch let error as NSError {
                print("Could not save \(error),\(error.userInfo)")
            }
        }
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let vc = segue.destination as! EditViewController
         vc.managedContext = self.managedContext
         if segue.identifier == "editSegue"{
             vc.titleString = "Update Person"
             if let indexPath = self.tableView.indexPathForSelectedRow{
                 vc.person = self.persons[indexPath.row]
            }
         }
         else{
            vc.titleString = "Insert Person"
        }
    }
}
