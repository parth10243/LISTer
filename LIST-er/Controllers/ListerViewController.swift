//
//  ViewController.swift
//  LIST-er
//
//  Created by Parth on 1/10/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit
import CoreData

class ListerViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for:  .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
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
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
     
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
     
    //MARK: Onclick of a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        tableView.deselectRow(at: indexPath , animated: true)
    }
    
    //MARK: Add bar button

    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new list", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItem()
        }
        alert.addTextField { ( alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
    
    
    }
    
    func saveItem(){
        do{
            try context.save()
        } catch{
            print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate ])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error in fetching data \(error)")
        }
        tableView.reloadData()
    }
    
}

//MARK: - Search Bar Extension

extension ListerViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
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

 
