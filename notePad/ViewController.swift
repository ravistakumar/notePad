//
//  ViewController.swift
//  notePad
//
//  Created by rav subedi on 11/19/15.
//  Copyright © 2015 Ravi Kumar Subedi. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var uitableview: UITableView!
    var people = [NSManagedObject]()
    
    @IBAction func addName(sender: AnyObject) {
    let alert = UIAlertController(title: "Agenda", message: "Add New Task", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "save me😊👍", style: .Default, handler: {(action: UIAlertAction)-> Void in
        let textfield = alert.textFields!.first
        self.saveName(textfield!.text!)
        self.uitableview.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel ☹️",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    func saveName(name: String) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Person",
            inManagedObjectContext:managedContext)
        let person = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        person.setValue(name, forKey: "name")
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Person")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            people = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Personal Note 📒 🖊"
        uitableview.registerClass(UITableViewCell.self, forCellReuseIdentifier:"cell")
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
            return people.count
    }
    
    func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        let person = people[indexPath.row];
        cell!.textLabel!.text = person.valueForKey("name") as? String
            return cell!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

