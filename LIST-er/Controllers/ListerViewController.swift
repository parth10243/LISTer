//
//  ViewController.swift
//  LIST-er
//
//  Created by Parth on 1/10/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit
import RealmSwift

class ListerViewController: UITableViewController {
    
    let realm = try! Realm()
    var itemResults: Results<Item>?
    let dataFilePath = FileManager.default.urls(for:  .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for:  .documentDirectory, in: .userDomainMask))
    }
    
    //MARK: Tableview datasource method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        if let item = itemResults?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResults?.count ?? 1
    }
     
    //MARK: Onclick of a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemResults?[indexPath.row]{
            do{
                try realm.write{
                    item.done = !item.done
            }
            }catch{
                print("Error in updating done property \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath , animated: true)
    }
    
    //MARK: Add bar button

    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {

        var textField = UITextField()
        let alert = UIAlertController(title: "Add new list", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error in writing the item to db\(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { ( alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)

        present(alert, animated: true, completion: nil )


    }
    
 

    func loadItems(){
        itemResults = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Extension

extension ListerViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemResults = itemResults?.filter("title CONTAINS[cd] %@", searchBar.text! ).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


