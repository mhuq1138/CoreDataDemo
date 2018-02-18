//
//  EditViewController.swift
//  CoreDataDemo
//
//  Created by Mazharul Huq on 2/16/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class EditViewController: UIViewController {

    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var dobField: UITextField!
    
    var titleString = ""
    var dateFormatter:DateFormatter!
    var managedContext:NSManagedObjectContext!
    var person:NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        self.firstNameField.text = person?.value(forKey: "firstName") as? String
        self.lastNameField.text = person?.value(forKey: "lastName") as? String
        if let dob = person?.value(forKey: "dateOfBirth") as? Date{
            self.dobField.text = dateFormatter.string(from: dob)
        }
    }

    
    @IBAction func saveTapped(_ sender: Any) {
        var personToSave:NSManagedObject
        
        //Configure a managed object
        if let person = self.person{
            personToSave = person
        }
        else{
            //1 Creating an instance of entity description
            let entity = NSEntityDescription.entity(forEntityName: "Person", in: self.managedContext)
            //2 Instance of NSManagedObject using entity
            personToSave = NSManagedObject(entity: entity!, insertInto: self.managedContext)
        }
        
        //Assign values to the properties of the managed object
        personToSave.setValue(self.firstNameField.text, forKey: "firstName")
        personToSave.setValue(self.lastNameField.text, forKey: "lastName")
        personToSave.setValue(dateFormatter.date(from: dobField.text!) as NSDate?, forKey: "dateOfBirth")
        
        //Save changes to the context
        if self.managedContext.hasChanges {
            do {
                try self.managedContext.save()
            }
            catch {
                let nserror = error as NSError
                print("Could not save \(nserror),(nserror.userInfo)")
            }
        }
        navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
