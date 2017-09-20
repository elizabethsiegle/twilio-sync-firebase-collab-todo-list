//
//  ToDoListTableViewController.swift
//  TwilioSyncCollabToDoList
//
//  Created by Elizabeth Siegle on 9/18/17.
//  Copyright © 2017 Elizabeth Siegle. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    var toDoItems: NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.toDoItems.count
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        let source: AddToDoViewController = segue.source as! AddToDoViewController
        if let item: ToDoItem = source.toDoItem{
            self.toDoItems.add(item)
            self.tableView.reloadData()
        }
    }
    func loadInitialData(){
        
        let item1 = ToDoItem(name: "Email Nikita")
        self.toDoItems.add(item1
        )
        
        let item2 = ToDoItem(name: "finish Speech synthesis lab")
        self.toDoItems.add(item2)
        
        let item3 = ToDoItem(name: "read AI chapter 2")
        self.toDoItems.add(item3)
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let CellIndentifier: NSString = "ListPrototypeCell"
        
        let cell : UITableViewCell
             = tableView.dequeueReusableCell(withIdentifier: CellIndentifier as String)!
        
        let todoitem: ToDoItem = self.toDoItems.object(at: indexPath.row) as! ToDoItem
        
        cell.textLabel?.text = todoitem.itemName as String
        if todoitem.completed {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none 
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        
        let tappedItem: ToDoItem = self.toDoItems.object(at: indexPath.row) as!
            
        ToDoItem
        
        tappedItem.completed = !tappedItem.completed
        
        tableView.reloadData()
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
