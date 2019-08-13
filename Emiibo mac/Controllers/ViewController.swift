//
//  ViewController.swift
//  Emiibo mac
//
//  Created by midyro on 10/08/2019.
//  Copyright © 2019 midyro. All rights reserved.
//

import Cocoa
import Alamofire

class ViewController: NSViewController {

    @IBOutlet weak var name: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var gameSeries: NSTextField!
    @IBOutlet weak var previewImage: NSImageView!
    @IBOutlet weak var selectLabel: NSTextField!
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var randomUuid: NSButton!
    @IBOutlet weak var generateButton: NSButton!
    
    var data: AmiiboResponse?
    var itemSelected: Amiibo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AmiiboHelper.shared.getAmiibos(completion: { (data) in
            self.setData(data: data!)
        })
        
        name.stringValue = ""
        gameSeries.stringValue = ""
        
        nameTextField.isHidden = true
        randomUuid.isHidden = true
        generateButton.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    @IBAction func generateJson(_ sender: Any) {
        if let amiibo = self.itemSelected {
            let checkboxState = (randomUuid.state == NSControl.StateValue.on)
            AmiiboHelper.shared.generateJson(amiibo: amiibo, randomUuid: checkboxState, name: nameTextField.stringValue)
        }
    }
    
    func setData(data: AmiiboResponse) {
        self.data = data
        self.tableView.reloadData()
    }
}

extension ViewController: NSTableViewDataSource, NSTableViewDelegate
{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return data?.amiibo.count ?? 0
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let amiibo = data?.amiibo[row]
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        
        if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "NameId") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "NameId")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = amiibo?.name ?? "not available"
            return cellView
            
        } else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "GameSerieId") {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "GameSerieId")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier, owner: self) as? NSTableCellView else { return nil }
            cellView.textField?.stringValue = amiibo?.gameSeries ?? "not available"
            return cellView
        }

        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        if tableView.selectedRow >= 0 {
            self.itemSelected = data?.amiibo[tableView.selectedRow]
            
            Alamofire.request(itemSelected!.image).responseImage { response in
                if response.result.value != nil {
                   self.previewImage.image = NSImage(data: response.data!)!
                }
            }

            name.stringValue = itemSelected?.name ?? "Test"
            gameSeries.stringValue = itemSelected?.gameSeries ?? "Test"
            nameTextField.stringValue = itemSelected?.name ?? "Amiibo"
            selectLabel.isHidden = true
            
            nameTextField.isHidden = false
            randomUuid.isHidden = false
            generateButton.isHidden = false
        }
    }
}
