//
//  ViewController.swift
//  DragAndDropDemo
//
//  Created by Shawn Roller on 10/18/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    
    @IBOutlet weak var colorSelection: UICollectionView!
    @IBOutlet weak var savedPostcards: UICollectionView!
    @IBOutlet weak var postcard: UIImageView!
    
    var colors = [UIColor]()
    var postcards = [UIImage]()
    var image: UIImage?
    var topText = "Visit Hell"
    var topFontName = "Helvetica Neue"
    var topColor = UIColor.white
    var bottomText = "Home of Satan and his Minions"
    var bottomFontName = "Helvetica Neue"
    var bottomColor = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit Postcard"
        self.splitViewController?.view.backgroundColor = UIColor.lightGray
        
        setupDragAndDrop()
        
        createColors()
        
        renderPostcard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createColors() {
        
        self.colors += [.black, .gray, .white, .yellow, .orange, .red, .magenta, .purple, .blue, .cyan, .green]
        
        for i in 0...9 {
            for j in 1...10 {
                let color = UIColor(hue: CGFloat(i) / 10, saturation: CGFloat(j) / 10, brightness: 1, alpha: 1)
                self.colors.append(color)
            }
        }
        
    }
    
    func setupDragAndDrop() {
        
        self.colorSelection.dragDelegate = self
        self.postcard.isUserInteractionEnabled = true
        let dropInteraction = UIDropInteraction(delegate: self)
        self.postcard.addInteraction(dropInteraction)
        
        let dragInteraction = UIDragInteraction(delegate: self)
        self.postcard.addInteraction(dragInteraction)
        
        let saveDropInteraction = UIDropInteraction(delegate: self)
        self.savedPostcards.dropDelegate = self
        self.savedPostcards.dragDelegate = self
        self.savedPostcards.addInteraction(saveDropInteraction)
        
    }
    @IBAction func changeText(_ sender: UITapGestureRecognizer) {
        
        let location = sender.location(in: self.postcard)
        var changeTop = false
        if location.y < postcard.bounds.midY {
            changeTop = true
        }
        else {
            changeTop = false
        }
        
        let alert = UIAlertController(title: "Change Text", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter what you'd like to say"
            if changeTop {
                textField.text = self.topText
            }
            else {
                textField.text = self.bottomText
            }
        }
        
        alert.addAction(UIAlertAction(title: "Change", style: .default, handler: { (_) in
            guard let text = alert.textFields?.first?.text else { return }
            if changeTop {
                self.topText = text
            }
            else {
                self.bottomText = text
            }
            self.renderPostcard()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

// MARK: - Collection view datasource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.colorSelection {
            return self.colors.count
        }
        else if collectionView == self.savedPostcards {
            return self.postcards.count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.colorSelection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 5
            cell.backgroundColor = self.colors[indexPath.row]
            return cell
        }
        else if collectionView == self.savedPostcards {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SavedPostcardCollectionViewCell
            if indexPath.row >= self.postcards.count {
                // This is a placeholder for a new saved postcard
                cell.postcardImage.backgroundColor = .lightGray
                cell.postcardImage.alpha = 0.5
            }
            else {
                cell.postcardImage.alpha = 1
                cell.postcardImage.image = self.postcards[indexPath.row]
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}


// MARK: - Collection view delegate
extension ViewController: UICollectionViewDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: UIDropOperation.copy)
    }
    
}

// MARK: - Collection view drag delegate
extension ViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        if collectionView == self.colorSelection {
            let color = self.colors[indexPath.row]
            let provider = NSItemProvider(object: color)
            let item = UIDragItem(itemProvider: provider)
            return [item]
        }
        else if collectionView == self.savedPostcards {
            guard indexPath.row < self.postcards.count - 1 else { return [] }
            let image = self.postcards[indexPath.row]
            let provider = NSItemProvider(object: image)
            let item = UIDragItem(itemProvider: provider)
            return [item]
        }
        return []
    }
    
}

// MARK: - Collection view drop delegate
extension ViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard collectionView == self.savedPostcards else { return }
        let session = coordinator.session
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) {
            session.loadObjects(ofClass: UIImage.self, completion: { (items) in
                guard let image = items.first as? UIImage else { return }
                self.postcards.append(image)
                self.savedPostcards.reloadData()
            })
        }
    }
    
}

// MARK: - UIDragInteractionDelegate
extension ViewController: UIDragInteractionDelegate {
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let image = self.postcard.image else { return [] }
        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        return [item]
    }
    
}

// MARK: - UIDropInteractionDelegate
extension ViewController: UIDropInteractionDelegate {

    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        let location = session.location(in: self.postcard)
        
        if session.hasItemsConforming(toTypeIdentifiers: [kUTTypePlainText as String]) {
            // Handle strings
            session.loadObjects(ofClass: NSString.self, completion: { (items) in
                guard let string = items.first as? String else { return }
                if location.y < self.postcard.bounds.midY {
                    self.topFontName = string
                }
                else {
                    self.bottomFontName = string
                }
                self.renderPostcard()
            })
        }
        else if session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) {
            // Handle images
            session.loadObjects(ofClass: UIImage.self, completion: { (items) in
                guard let image = items.first as? UIImage else { return }
                self.image = image
                self.renderPostcard()
            })
        }
        else {
            // Handle colors
            session.loadObjects(ofClass: UIColor.self) { items in
                guard let color = items.first as? UIColor else { return }
                if location.y < self.postcard.bounds.midY {
                    self.topColor = color
                }
                else {
                    self.bottomColor = color
                }
                self.renderPostcard()
            }
        }
        
    }
    
}

// MARK: - Drawing
extension ViewController {
    
    func renderPostcard() {
        
        let drawRect = CGRect(x: 0, y: 0, width: 3000, height: 2400)
        let topTextRect = CGRect(x: 250, y: 200, width: 2500, height: 800)
        let bottomTextRect = CGRect(x: 250, y: 1800, width: 2500, height: 600)
        let topFont = UIFont(name: self.topFontName, size: 350) ?? UIFont.systemFont(ofSize: 250)
        let bottomFont = UIFont(name: self.bottomFontName, size: 150) ?? UIFont.systemFont(ofSize: 100)
        let centered = NSMutableParagraphStyle()
        centered.alignment = .center
        let topTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: self.topColor, .font: topFont, .paragraphStyle: centered]
        let bottomTextAttributes: [NSAttributedStringKey: Any] = [.foregroundColor: self.bottomColor, .font: bottomFont, .paragraphStyle: centered]
        
        // Begin rendering
        let renderer = UIGraphicsImageRenderer(size: drawRect.size)
        self.postcard.image = renderer.image { ctx in
            
            // Draw the background color to be solid gray
            UIColor.gray.set()
            ctx.fill(drawRect)
            
            // Draw the user's image
            image?.draw(at: CGPoint(x: 0, y: 0))
            
            // Draw the top and bottom text
            self.topText.draw(in: topTextRect, withAttributes: topTextAttributes)
            self.bottomText.draw(in: bottomTextRect, withAttributes: bottomTextAttributes)
            
        }
        
    }
    
}
