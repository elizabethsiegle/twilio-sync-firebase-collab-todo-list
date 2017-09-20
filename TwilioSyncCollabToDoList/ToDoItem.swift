//
//  ToDoItem.swift
//  TwilioSyncCollabToDoList
//
//  Created by Elizabeth Siegle on 9/19/17.
//  Copyright © 2017 Elizabeth Siegle. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    var itemName: NSString = ""
    var completed: Bool = false
    var creationDate: NSDate = NSDate()
    
    init(name:String){
        self.itemName = name as NSString
        
    }

}
