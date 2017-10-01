//
//  ToDoListTableViewController.swift
//  TwilioSyncCollabToDoList
//
//  Created by Elizabeth Siegle on 9/18/17.
//  Copyright © 2017 Elizabeth Siegle. All rights reserved.
//

import UIKit
import TwilioSyncClient

class ToDoListTableViewController: UITableViewController, TWSDocumentDelegate {
    @IBOutlet var listCollectionView: UICollectionView!
    var syncClient : TwilioSyncClient?
    var toDoItems: NSMutableArray = []
    var document : TWSDocument?
    let urlString = "http://af590533.ngrok.io/token"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.listCollectionView.contentInset = UIEdgeInsetsMake(8, 8, 8, 8)
        self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        login()
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
        return self.toDoItems.count
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        let source: AddToDoViewController = segue.source as! AddToDoViewController
        if let item: ToDoItem = source.toDoItem{
            self.toDoItems.add(item)
            self.tableView.reloadData()
        }
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
        let newData = ["listelement": cell]
        document?.setData(newData, flowId: 1, completion: { (result) in
            if !(result?.isSuccessful())! {
                print("TTT: error updating the list: \(String(describing: result?.error))")
            }
        })
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: false)
        let tappedItem: ToDoItem = self.toDoItems.object(at: indexPath.row) as!ToDoItem
        tappedItem.completed = !tappedItem.completed
        tableView.reloadData()
    }
    
    func login() {
        if self.syncClient != nil {
            logout()
        }
        _ = generateToken()
        TokenUtils.retrieveToken(url: urlString) { (token, identity, error) in
            if let token = token {
                let properties = TwilioSyncClientProperties()
                self.syncClient = TwilioSyncClient(token: token,
                                                   properties: properties,
                                                   delegate: self as? TwilioSyncClientDelegate)
            }
        }
    }
    
//    func login(completion: @escaping (_ syncClient: TwilioSyncClient?) -> Void) {
//        if self.syncClient != nil {
//            logout()
//        }
//
//        let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString
//        let urlString = "\(AppConstants.TOKEN_URL)?device=\(identifierForVendor!)"
//        //let urlString = "https://67fa57c2.ngrok.io"
//        let token = generateToken()
//        let properties = TwilioSyncClientProperties()
////        if let token = token {
////            self.syncClient = TwilioSyncClient(token: token, properties: properties, delegate: self as? TwilioSyncClientDelegate)
////        }
//        TokenUtils.retrieveToken(url: urlString) { (token, identity, error) in
//            if let token = token {
//                let properties = TwilioSyncClientProperties()
//                self.syncClient = TwilioSyncClient(token: token,
//                                                   properties: properties,
//                                                   delegate: self as? TwilioSyncClientDelegate)
//            }
//        }
//    }
    
    func updateListFromDoc() {
        if let document = document {
            let data = document.getData()
            if (data["listelement"] as? [[String]]) != nil {
                self.tableView.reloadData()
            } else {
                //                self.currentBoard = emptyBoard()
                print("here in update list from doc")
            }
            DispatchQueue.main.async(execute: {
                self.listCollectionView.reloadData()
            })
        }
    }
    
    func logout() {
        if let syncClient = syncClient {
            syncClient.shutdown()
            self.syncClient = nil
        }
    }
    
    fileprivate func generateToken() -> String? {
        
        
        var token : String?
        do {
            if let url = URL(string: urlString),
                let data = try? Data(contentsOf: url),
                let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
                token = result["token"] as? String
            }
        } catch {
            print("Error obtaining token: \(error)")
        }
        print ("returning token")
        return token
    }
    func onDocumentResultUpdated(_ document: TWSDocument, forFlowID flowId: UInt) {
        self.updateListFromDoc()
    }
    
    public func onDocument(_ document: TWSDocument, remoteUpdated data: [String : Any]) {
        self.updateListFromDoc()
    }
}

extension UITableViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3*3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Square", for: indexPath)
        
//        if let label = cell.viewWithTag(100) as! UILabel? {
//            if self.document != nil {
//                let row = indexPath.row / 3
//                let col = indexPath.row % 3
//
//                cell.backgroundColor = UIColor.white
//                label.text = "currentBoard[row][col]"
//            } else {
//                cell.backgroundColor = UIColor.lightGray
//                label.text = ""
//            }
//        }
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
//            if let label = footerView.viewWithTag(200) as! UILabel? {
//                if self.document != nil {
//                    label.text = "Sync is initialized"
//                } else {
//                    label.text = "Sync is not yet initialized"
//                }
//            }
            return footerView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
            return headerView
        }
    }
}
//extension UITableViewController: TWSDocumentDelegate {
//
//}



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
