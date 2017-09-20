//
//  AddToDoViewController.swift
//  TwilioSyncCollabToDoList
//
//  Created by Elizabeth Siegle on 9/19/17.
//  Copyright © 2017 Elizabeth Siegle. All rights reserved.
//

import UIKit

class AddToDoViewController: UIViewController {
    var toDoItem: ToDoItem?
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if sender as? NSObject != self.doneButton {
            return
        }
        if (self.textField.text?.utf16.count)! > 0 {
            self.toDoItem = ToDoItem(name: self.textField.text!)
        }
        else {
            print("here")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent!) {
        self.view.endEditing(true)
    }
 

}
