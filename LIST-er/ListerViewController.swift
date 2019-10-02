//
//  ViewController.swift
//  LIST-er
//
//  Created by Parth on 1/10/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit

class ListerViewController: UITableViewController {

    let itemArray = ["Option1", "Option2", "Option3"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK :  Tableview datasource method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
     
    //MARK : Onclick of a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        if (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath , animated: true)
    }

}

