//
//  SwipeTableViewController.swift
//  LIST-er
//
//  Created by Parth on 21/10/19.
//  Copyright © 2019 Parth. All rights reserved.
//

import UIKit
import SwipeCellKit
 
class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
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

            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")

            return [deleteAction]
        }
        
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }

  

}
