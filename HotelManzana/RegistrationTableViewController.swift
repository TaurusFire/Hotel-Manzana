//
//  RegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Cheks Nweze on 06/09/2020.
//  Copyright © 2020 Cheks. All rights reserved.
//

import UIKit


class RegistrationTableViewController: UITableViewController {
    
    @IBAction func unwindFromAddRegistration(unwindSegue: UIStoryboardSegue) {
        guard let addRegistrationController = unwindSegue.source as? AddRegistrationTableViewController,
            let registration = addRegistrationController.registration else {return}
                
        if let regPosition = tableView.indexPathForSelectedRow {
            registrations[regPosition.row] = registration
        } else {
            registrations.append(registration)
        }
        tableView.reloadData()
       }
    

    var registrations : [Registration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return registrations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let currentReg = registrations[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        cell.textLabel?.text = "\(currentReg.firstName) \(currentReg.lastName)"
        cell.detailTextLabel?.text = dateFormatter.string(from: currentReg.checkInDate) + " - " + dateFormatter.string(from: currentReg.checkOutDate) + ": " + currentReg.roomType.name

        return cell
    }


    
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "viewDetailsSegue" {
            
            guard let regPosition = tableView.indexPathForSelectedRow else {return}
                        
            let navVC = segue.destination as? UINavigationController
            let addVC = navVC?.viewControllers.first as? AddRegistrationTableViewController
            addVC?.roomType = registrations[regPosition.row].roomType
            addVC?.currentReg = registrations[regPosition.row]
        }
    }
    
}
