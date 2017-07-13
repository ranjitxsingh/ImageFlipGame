//
//  FlikrCell.swift
//  FlikrSearch
//
//  Created by Ranjit Singh on 26/05/17.
//  Copyright © 2017 Flikr. All rights reserved.
//

import UIKit

class FlikrCell: UICollectionViewCell {
    
    @IBOutlet weak var imgIcon:UIImageView!
    
    var flikr:Flikr? = nil {
        willSet(newValue) {
            guard let value = newValue else { return}
            
            if value.isFlipped {
                let transitionOptions = UIViewAnimationOptions.transitionFlipFromLeft
                UIView.transition(with: self.contentView, duration: 0.5, options: transitionOptions, animations: { 

                }, completion: { (finished) in
                    self.imgIcon.image = UIImage(named: "Flipped-Image")
                })
            } else {
                ImageDownloader.getImage(image: value.secret, urlString: value.imageURL) { (image) in
                    self.imgIcon.image = image
                }
            }
        }
    }
}

