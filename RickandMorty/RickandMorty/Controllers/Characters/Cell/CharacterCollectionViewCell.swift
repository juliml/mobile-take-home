//
//  CharacterCollectionViewCell.swift
//  RickandMorty
//
//  Created by Juliana Lacerda on 2019-07-07.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageCharacter: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    func set(image: UIImage?) {
        imageCharacter.image = image
        
        if image == nil {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

}
