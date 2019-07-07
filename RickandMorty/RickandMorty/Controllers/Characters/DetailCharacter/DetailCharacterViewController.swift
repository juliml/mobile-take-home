//
//  DetailCharacterViewController.swift
//  RickandMorty
//
//  Created by Juliana Lacerda on 2019-07-06.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

class DetailCharacterViewController: UIViewController {

    @IBOutlet var imageCharacter: UIImageView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var descriptionCharacter: UILabel!
    
    public var character: Character!
    var charactersViewModel: CharactersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.activityIndicator.startAnimating()
        self.charactersViewModel = CharactersViewModel()
        self.loadCharacter()
        
    }
    
    func loadCharacter(){
        
        charactersViewModel?.getCharacterImage(character: character, completion: { (image) in
            
            guard let image = image else {return}
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.imageCharacter.image = image
            }
        
        })
        
        descriptionCharacter.minimumScaleFactor = 0.1
        descriptionCharacter.adjustsFontSizeToFitWidth = true
        
        descriptionCharacter.text = """
        Name: \(character.name!)
        ----------
        Status: \(character.status!)
        ----------
        Specie: \(character.species!)
        ----------
        Gender: \(character.gender!)
        ----------
        Origin: \(character.origin!.name)
        """
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
