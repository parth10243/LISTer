//
//  ViewController.swift
//  LIST-er
//
//  Created by Parth on 1/10/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ListerViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    let realm = try! Realm()
    var itemResults: Results<Item>?
//    let dataFilePath = FileManager.default.urls(for:  .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for:  .documentDirectory, in: .userDomainMask))
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if let colourHex = selectedCategory?.rowColour{
//            guard let navbar = navigationController?.navigationBar else {
//                fatalError("Navigation error doesnt exist")
//            }
//            navbar.barTintColor = UIColor(hexString: colourHex)
//        }
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller doesn't exist.")}
        let colour = selectedCategory!.rowColour
//        if let colour = selectedCategory?.rowColour {
//
//               if #available(iOS 13.0, *) {
//                   let app = UINavigationBarAppearance().self
//
//                   app.backgroundColor = UIColor(hexString: colour)
//
//                   navBar.standardAppearance = app
//                   navBar.compactAppearance = app
//                   navBar.scrollEdgeAppearance = app
//
//               } else {
//                   navBar.barTintColor = UIColor(hexString: colour)
//               }
            title = selectedCategory!.name
            searchBarOutlet.barTintColor = UIColor(hexString: colour)
            navBar.tintColor = ContrastColorOf(UIColor(hexString: colour)!, returnFlat: true)
            navBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(UIColor(hexString: colour)! , returnFlat: true)]
           
    }
    
    //MARK: Tableview datasource method
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemResults?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let colour = UIColor(hexString: selectedCategory!.rowColour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(itemResults!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour , returnFlat: true)
            }
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
        loadItems()
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

    //MARK: Item deletion methods
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = itemResults?[indexPath.row]{
            do{
                try realm.write {
                    realm.delete(itemToDelete)
                }
            }catch{
                print("Error in deleting error \(error)")
            }
        }
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


