//
//  ViewController.swift
//  ToDo List
//
//  Created by sangpil on 02/01/2018.
//  Copyright © 2018 sangpil. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var toDoItems:[ToDoItem] = []
    var saveSelectedIndexOfTable:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getToDoItems()
        // Do any additional setup after loading the view.
    }

    func getToDoItems() {
        //get the todoitem from ...
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                toDoItems = try context.fetch(ToDoItem.fetchRequest())
//                print(toDoItems.count)
            } catch {
                
            }
        }
        //set them to the class property
        //update the table
        tableView.reloadData()
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if textField.stringValue != "" {
            if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let toDoItem = ToDoItem(context: context)
                toDoItem.name = textField.stringValue
                if importantCheckbox.state == NSControl.StateValue.off {
                    //not important
                    toDoItem.important = false
                } else {
                    // important
                    toDoItem.important = true
                }
                
                (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
                
                textField.stringValue = ""
                importantCheckbox.state = NSControl.StateValue.off
                
                getToDoItems()
            }
        }
    }
    
    @IBAction func deleteBtnClicked(_ sender: Any) {
        let toDoItem = toDoItems[tableView.selectedRow]
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(toDoItem)
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            getToDoItems()
            
            deleteButton.isHidden = true
        }
    }
    
    
    // MARK: - TableView Stuff
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let toDoItem = toDoItems[row]
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier("importantColumn") {
            
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("importantCell"), owner: self) as? NSTableCellView {
                if toDoItem.important {
                    cell.textField?.stringValue = "!"
                } else {
                    cell.textField?.stringValue = ""
                }
                return cell
            }
            
        } else {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("todoitems"), owner: self) as? NSTableCellView {
                cell.textField?.stringValue = toDoItem.name!
                return cell
            }
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        
        print(tableView.selectedRow)
        if tableView.selectedRow == -1 {
            deleteButton.isHidden = true
        }else{
            deleteButton.isHidden = false
        }
        
        saveSelectedIndexOfTable = tableView.selectedRow
        
    }
}

