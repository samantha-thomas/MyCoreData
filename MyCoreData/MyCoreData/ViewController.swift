//
//  ViewController.swift
//  MyCoreData
//
//  Created by Samantha Thomas on 10/22/19.
//  Copyright © 2019 Samantha Thomas. All rights reserved.
//

import UIKit

import CoreData;

class ViewController: UIViewController
{
    //Outlets
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var middleinitial: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var btnBack: UIBarButtonItem!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var birthdate: UITextField!
    @IBOutlet weak var relationship: UITextField!
    
    //Actions
    @IBAction func btnBack(_ sender: UIBarButtonItem)
    {
        //Got this from my lab assignment as well.
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSave(_ sender: UIButton)
    {
        //This code was taken from my lab assignment and updated.
        if (contactdb != nil)
         {
             
            contactdb.setValue(firstname.text, forKey: "firstname")
            contactdb.setValue(middleinitial.text, forKey: "middleinitial")
            contactdb.setValue(lastname.text, forKey: "lastname")
            
            contactdb.setValue(address.text, forKey: "address")
            contactdb.setValue(city.text, forKey: "city")
            contactdb.setValue(state.text, forKey: "state")
            contactdb.setValue(zipcode.text, forKey: "zipcode")
            
            contactdb.setValue(email.text, forKey: "email")
            contactdb.setValue(phone.text, forKey: "phone")
            
            contactdb.setValue(birthdate.text, forKey: "birthdate")
            contactdb.setValue(relationship.text, forKey: "relationship")
         }
         else
         {
             let entityDescription =
                NSEntityDescription.entity(forEntityName: "Contacts",in: managedObjectContext)
             
             let contacts = Contacts(entity: entityDescription!,
                                     insertInto: managedObjectContext)
             
             contacts.firstname = firstname.text!
             contacts.middleinitial = middleinitial.text!
             contacts.lastname = lastname.text!
             
             contacts.address = address.text!
             contacts.city = city.text!
             contacts.state = state.text!
             contacts.zipcode = zipcode.text!
             
             contacts.email = email.text!
             contacts.phone = phone.text!
             
             contacts.birthdate = birthdate.text!
             contacts.relationship = relationship.text!
         }
         var error: NSError?
         do
         {
            try managedObjectContext.save()
         }
         catch let error1 as NSError
         {
            error = error1
         }
        
        if error != nil
         {
            //if error occurs
           // status.text = err.localizedFailureReason
         }
         else
         {
            self.dismiss(animated: false, completion: nil)
            
         }
    }
    
    @IBAction func btnEdit(_ sender: UIButton)
    {
        firstname.isEnabled = true
        middleinitial.isEnabled = true
        lastname.isEnabled = true
        
        address.isEnabled = true
        city.isEnabled = true
        state.isEnabled = true
        zipcode.isEnabled = true
        
        email.isEnabled = true
        phone.isEnabled = true
        
        birthdate.isEnabled = true
        relationship.isEnabled = true
        
        firstname.becomeFirstResponder()
    }
    
    //Gotten from my lab project that I placed on GitHub.
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contactdb:NSManagedObject!
    
    override func viewDidLoad()
    {
        if (contactdb != nil)
        {
            //This was also used in my lab assignment. It was updated for this app.
            firstname.text = contactdb.value(forKey: "firstname") as? String
            middleinitial.text = contactdb.value(forKey: "middleinitial") as? String
            lastname.text = contactdb.value(forKey: "lastname") as? String
            
            address.text = contactdb.value(forKey: "address") as? String
            city.text = contactdb.value(forKey: "city") as? String
            state.text = contactdb.value(forKey: "state") as? String
            zipcode.text = contactdb.value(forKey: "zipcode") as? String
            
            email.text = contactdb.value(forKey: "email") as? String
            phone.text = contactdb.value(forKey: "phone") as? String
            
            birthdate.text = contactdb.value(forKey: "birthdate") as? String
            relationship.text = contactdb.value(forKey: "relationship") as? String
            
            btnSave.setTitle("Update", for: UIControl.State())
           
            btnEdit.isHidden = false
            
            firstname.isEnabled = false
            middleinitial.isEnabled = false
            lastname.isEnabled = false
            
            address.isEnabled = false
            city.isEnabled = false
            state.isEnabled = false
            zipcode.isEnabled = false
            
            email.isEnabled = false
            phone.isEnabled = false
            
            birthdate.isEnabled = false
            relationship.isEnabled = false
            
            btnSave.isHidden = true
        }
        else
        {
          
            btnEdit.isHidden = true
            
            firstname.isEnabled = true
            middleinitial.isEnabled = true
            lastname.isEnabled = true
            
            address.isEnabled = true
            city.isEnabled = true
            state.isEnabled = true
            zipcode.isEnabled = true
            
            email.isEnabled = true
            phone.isEnabled = true
            
            birthdate.isEnabled = true
            relationship.isEnabled = true
        }
        firstname.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
        //Looks for single or multiple taps
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.DismissKeyboard))
        
        //Adds tap gesture to view
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //I got these from my lab project. I know that these features would
    //be required so I brought them over off of yesterday's assignment
    //that I shared on GitHub.
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches , with:event)
        if (touches.first as UITouch?) != nil
        {
            DismissKeyboard()
        }
    }
    
    @objc func DismissKeyboard()
    {
        //forces resign first responder and hides keyboard
        firstname.endEditing(true)
        middleinitial.endEditing(true)
        lastname.endEditing(true)
        
        address.endEditing(true)
        city.endEditing(true)
        state.endEditing(true)
        zipcode.endEditing(true)
        
        email.endEditing(true)
        phone.endEditing(true)
        
        birthdate.endEditing(true)
        relationship.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
}

