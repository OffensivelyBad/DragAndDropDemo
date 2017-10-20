//
//  FontsViewController.swift
//  DragAndDropDemo
//
//  Created by Shawn Roller on 10/18/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit
import MobileCoreServices

class FontsViewController: UITableViewController {

    let fonts = UIFont.familyNames.sorted()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Fonts"
        
        self.tableView.dragDelegate = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fonts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let font = self.fonts[indexPath.row]
        cell.textLabel?.text = font
        cell.textLabel?.font = UIFont(name: font, size: 18)
        return cell
    }
    
}

// MARK: - UITableViewDragDelegate
extension FontsViewController: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let string = self.fonts[indexPath.row]
        
        // If we return an empty array we essentially tell iOS to cancel the drag session
        guard let data = string.data(using: .utf8) else { return [] }
        
        let provider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
    
}
