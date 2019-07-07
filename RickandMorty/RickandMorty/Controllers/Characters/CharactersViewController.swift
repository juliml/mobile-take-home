//
//  CharactersViewController.swift
//  RickandMorty
//
//  Created by Juliana Lacerda on 2019-07-06.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

class CharactersViewController: UICollectionViewController, ImageTaskDownloadedDelegate {

    var charactersViewModel: CharactersViewModel?
    public var episode: Episode!
    var imageTasks: [[ImageTask]] = []
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = episode.name! + " (\(episode.episode!))"
        
        self.showLoading()
        self.charactersViewModel = CharactersViewModel()
        self.makeCharactersRequest()
    }
    
    func makeCharactersRequest() {
        
        self.charactersViewModel?.getAllCharactersByEpisode(list: episode.characters!, completionHandler: { (error) in
            self.hideLoading()
            self.finishFetchingImages()
            
            if let error = error {
                print("-->> Error get characters [VC]: \(error.localizedDescription)")
                self.showAlert(title: "Sorry..." , message: error.localizedDescription)
            }
        })
        
    }
    
    private func finishFetchingImages() {
        DispatchQueue.main.async {
            self.setupImageTasks()
            self.collectionView?.reloadData();
        }
    }
    
    func setupImageTasks() {

        for i in 0..<2 {
            let total = self.charactersViewModel?.numberOfRows(i)
            var images:[ImageTask] = []
            
            for z in 0..<total! {
                let character = self.charactersViewModel?.getCharacterResponseBy(index: z, section: i)
                let url = URL(string: (character?.image)!)!
                
                let imageTask = ImageTask(index: z, section:i, url: url, delegate: self)
                images.append(imageTask)
            }
            
            imageTasks.append(images)
        }
        
    }
    
    //MARK: - ImageTaskDownloadedDelegate
    
    func imageDownloaded(index: Int, section: Int) {
        self.collectionView?.reloadItems(at: [IndexPath(row: index, section: section)])
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (charactersViewModel?.numberOfRows(section))!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "characterCell", for: indexPath) as? CharacterCollectionViewCell else {
                preconditionFailure("Invalid cell type")
        }
        
        let image = imageTasks[indexPath.section][indexPath.row].image
        cell.set(image: image)
        cell.backgroundColor = .black

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        var reusableView : UICollectionReusableView? = nil
        if (kind == UICollectionView.elementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCell", for: indexPath) as! HeaderCollectionReusableView
            
            if (indexPath.section == 0) {
                headerView.titleLabel.text = "Dead"
            } else {
                headerView.titleLabel.text = "Alive"
            }
            reusableView = headerView
        }
        
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40.0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageTasks[indexPath.section][indexPath.row].resume()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageTasks[indexPath.section][indexPath.row].pause()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPaths : NSArray = collectionView.indexPathsForSelectedItems! as NSArray
        let indexPath : IndexPath = indexPaths[0] as! IndexPath
        
        guard let detailView = segue.destination as? DetailCharacterViewController else {
            fatalError("indexPath, view nil")
        }
        
        if let characterResult: Character = charactersViewModel?.getCharacterResponseBy(index: indexPath.row, section: indexPath.section) {
            detailView.character = characterResult
        }
        
    }

}

extension CharactersViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}
