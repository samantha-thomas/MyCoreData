//
//  ContactsTableViewController.swift
//  MyCoreData
//
//  Created by Samantha Thomas on 10/22/19.
//  Copyright © 2019 Samantha Thomas. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class ContactsTableViewController: UITableViewController
{
    var filteredTableData = [NSManagedObject]()
    var resultSearchController = UISearchController()
    var contactArray = [NSManagedObject]()
    //var indexPath = [NSIndexPath]()
    
    //Gotten and updated from my lab assignment.
    func updateSearchResults(for searchController: UISearchController)
    {
        filteredTableData.removeAll(keepingCapacity: false)
        //search for field in CoreData
        let searchPredicate = NSPredicate(format: "firstname CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (contactArray as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [NSManagedObject]
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loaddb()
    }
    
    func loaddb()
    {
        let managedContext = (UIApplication.shared.delegate
            as! AppDelegate).persistentContainer.viewContext
        
        //let fetchRequest = NSFetchRequest(entityName:"Contact")
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Contacts")
        
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                contactArray = results
                tableView.reloadData()
            } else {
                print("Could not fetch")
            }
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription),\(error.userInfo)")
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        //Uncomment the following line to display an Edit button in the navigation
        //bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.resultSearchController.delegate = self as? UISearchControllerDelegate
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.delegate = self as? UISearchControllerDelegate
            controller.searchResultsUpdater = self as? UISearchResultsUpdating
            //controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.delegate = self as? UISearchBarDelegate
            self.tableView.tableHeaderView = controller.searchBar
            return controller
        })()
    }
    
    override func didReceiveMemoryWarning()
    {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       //#warning Incomplete implementation, return the number of rows.
        if (self.resultSearchController.isActive)
        {
            return filteredTableData.count
        }
        else
        {
            return contactArray.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        if (self.resultSearchController.isActive)
        {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell")
                    as UITableViewCell?
            let person = filteredTableData[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "firstname") as! String?
            cell?.detailTextLabel?.text = ">>"
            return cell!
        }
        else
        {
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell")
                    as UITableViewCell?
            let person = contactArray[(indexPath as NSIndexPath).row]
            cell?.textLabel?.text = person.value(forKey: "firstname") as! String?
            cell?.detailTextLabel?.text = ">>"
            return cell!
        }
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You selected cell #\((indexPath as NSIndexPath).row)")
    }

    //Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        //Return false if you do not want the specified item to be editable.
        return true
    }

    //Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let context = (UIApplication.shared.delegate
                as! AppDelegate).persistentContainer.viewContext
            if (self.resultSearchController.isActive)
            {
                context.delete(filteredTableData[(indexPath as NSIndexPath).row])
            }
            else
            {
                context.delete(contactArray[(indexPath as NSIndexPath).row])
            }
            
            var error: NSError? = nil
            do
            {
                try context.save()
                loaddb()
            }
            catch let error1 as NSError
            {
                error = error1
                print("Unresolved error \(String(describing: error))")
                abort()
            }
        }
    }

    /*
    //Override to support rearranging the table view.
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "UpdateContacts"
        {
            if let destination = segue.destination as?
                ViewController
            {
                if (self.resultSearchController.isActive)
                {
                    if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row
                    {
                        let selectedDevice:NSManagedObject = filteredTableData[SelectIndex] as NSManagedObject
                        destination.contactdb = selectedDevice
                        resultSearchController.isActive = false
                    }
                }
                else
                {
                    if let SelectIndex = (tableView.indexPathForSelectedRow as NSIndexPath?)?.row
                    {
                        let selectedDevice:NSManagedObject = contactArray[SelectIndex] as NSManagedObject
                        destination.contactdb = selectedDevice
                    }
                }
            }
        }
    }
}
