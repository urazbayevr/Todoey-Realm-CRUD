//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Рамазан  on 8/10/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

//class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//// MARK: - Table view data source
//    
////MARK: - swipe view delegate
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//        
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            if let category = self.categories?[indexPath.row]{
//                        do{
//                            try self.realm.write{ ///updates the database
//                                self.realm.delete(category)
//                            }
//                        } catch {
//                            print("Error catched on Updating data\(error)")
//                        }
//                    }
//        }
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "trash-circle")
//        return [deleteAction]
//    }
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//}
