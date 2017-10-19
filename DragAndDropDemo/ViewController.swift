//
//  ViewController.swift
//  DragAndDropDemo
//
//  Created by Shawn Roller on 10/18/17.
//  Copyright © 2017 Shawn Roller. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorSelection: UICollectionView!
    @IBOutlet weak var postcard: UIImageView!
    
    var colors = [UIColor]()
    var image: UIImage?
    var topText = "Visit Hell"
    var topFontName = "Helvetica Neue"
    var topColor = UIColor.white
    var bottomText = "Home of Satan and his Minions"
    var bottomFontName = "Helvetica Neue"
    var bottomColor = UIColor.white
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

}

// MARK: - Collection view datasource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = self.colors[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        return cell
    }
    
    
}


// MARK: - Collection view delegate
extension ViewController: UICollectionViewDelegate {
    
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
