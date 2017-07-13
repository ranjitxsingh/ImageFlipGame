//
//  ViewController.swift
//  FlikrSearch
//
//  Created by Ranjit Singh on 26/05/17.
//  Copyright © 2017 Flikr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    struct Message {
        static let rememberIn15Secs = "You have 15 Secs to remember imag location"
        static let cellToIdentify = "Tap on a cell to identify the correct image"
        static let gameOver = "Game Over Sir !!!"
        static let wrongSelection = "Wrong Selection"
    }
    
    
    var flikrData = [Flikr]()
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var gameImage:UIImageView!
    @IBOutlet weak var lblMessage:UILabel!
    var isGameOver:Bool = false
    
    let random = Int(arc4random()) % 9
    
    var randomFlikr:Flikr {
        return flikrData[random]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFlikrData()
    }
    
    //MARK: Fetch Flikr Data
    func getFlikrData() {
        
        let flikrRequest = FlikrRequest(text: "dogs")
        RequestSender.sendRequest(flikrRequest: flikrRequest, succes: { [unowned self] (flikrList) in
            
            DispatchQueue.main.async {
                self.flikrData = flikrList
                self.collectionView.reloadData()
                self.flipAllCellAfter15Secs()
                self.lblMessage.text = Message.rememberIn15Secs
            }
        }) {(errorMessage) in
            print(errorMessage)
        }
    }
    
    /// Flip all the cell after 15 secs
    func flipAllCellAfter15Secs() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(15)) {
            for item in self.flikrData {
                item.isFlipped = true
            }
            self.collectionView.reloadData()
            
            ///Show game Image
            ImageDownloader.getImage(image: self.randomFlikr.secret, urlString: self.randomFlikr.imageURL) { (image) in
                DispatchQueue.main.async {
                    self.gameImage.image = image
                    self.lblMessage.text = Message.cellToIdentify
                }
            }
        }
    }
}


//MARK: UICollectionViewDelegate, UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
extension ViewController:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flikrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlikrCell", for: indexPath) as! FlikrCell
        cell.flikr = flikrData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isGameOver {
            UIAlertController.singleAlert(presentAt: self, header: Message.gameOver)
        } else {
            let selectedFlikr = flikrData[indexPath.item]
            if selectedFlikr == randomFlikr {
                selectedFlikr.isFlipped = false
                
                let selectedCell = collectionView.cellForItem(at: indexPath) as! FlikrCell
                selectedCell.flikr = selectedFlikr
                
                self.isGameOver = true
                self.lblMessage.text = Message.gameOver
                
            } else {
                UIAlertController.singleAlert(presentAt: self, header: Message.wrongSelection)
            }
        }
    }
    
    
    //UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds
        let cellWidth = screenRect.size.width / 3.0 - 5.0
        let size = CGSize(width: cellWidth, height: cellWidth)
        return size
    }
}



///Need a separate file to create UIAlertController extension. Need revamp.
///-----------------------------------------------------------------------
extension UIAlertController {
    class func singleAlert(presentAt view:UIViewController, header:String) {
        let alertView = UIAlertController(title: "Info", message: header, preferredStyle: .alert)
        let action = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        })
        alertView.addAction(action)
        view.present(alertView, animated: true, completion: nil)
    }
}

