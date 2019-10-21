//
//  CategoryTableViewController.swift
//  LIST-er
//
//  Created by Parth on 14/10/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {
    
    var categoryArray : Results<Category>?
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()
        tableView.rowHeight = 80.0

    }

    //MARK:
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
        }
        alert.addTextField { ( alertTextField) in
            alertTextField.placeholder = "Add a new category"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
        
    }
    
    //MARK: TableView Data source methods
     
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category added yet"
        return cell
        
    }
    
    //MARK: Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListerViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexpath.row]
            
        }
    }
    
    //MARK: Data manipulation method
    
    func save(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error in saving context : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategoryData(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    //MARK: Delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToBeDeleted = self.categoryArray?[indexPath.row]{
                            do{
                                try self.realm.write {
                                    self.realm.delete(categoryToBeDeleted)
                                }
                            }catch{
                                print("Error in deleting category \(error)")
                            }
                        }
    }




}
