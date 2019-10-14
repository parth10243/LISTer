//
//  CategoryTableViewController.swift
//  LIST-er
//
//  Created by Parth on 14/10/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoryData()

    }

    //MARK:
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add ", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategoryData()
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
        
    }
    
    //MARK: Table view Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ListerViewController
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexpath.row]
            
        }
    }
    
    //MARK: Data manipulation method
    
    func saveCategoryData(){
        
        do{
            try context.save()
        }catch{
            print("Error in saving context : \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategoryData(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            try categoryArray =  context.fetch(request)
        }catch{
            print("Error in loading category data \(error)")
        }
        tableView.reloadData()
        
    }
    

}
