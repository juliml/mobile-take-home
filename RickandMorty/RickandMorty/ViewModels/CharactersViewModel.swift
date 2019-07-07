//
//  CharactersViewModel.swift
//  RickandMorty
//
//  Created by Juliana Lacerda on 2019-07-06.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

class CharactersViewModel: NSObject {

    let rest = RestManager()
    var characters: [[Character]] = []
    
    let url = "https://rickandmortyapi.com/api/character/"
    
    func numberOfRows(_ section: Int) -> Int{
        return characters.count > 0 ? characters[section].count : 0
    }
    
    func getCharacterResponseBy(index: Int, section: Int) -> Character? {
        return characters[section][index]
    }
    
    func getAllCharactersByEpisode(list: [String], completionHandler: @escaping (Error?) -> Void) {
        
        var multipleCharacters:[String] = []
        for characterUrl in list {
            let characterID = characterUrl.components(separatedBy: "/")[5]
            multipleCharacters.append(characterID)
        }
        
        let newUrl = url + "[\(multipleCharacters.joined(separator:","))]"
        
        guard let url = URL(string: newUrl) else { return }
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            
            if let error = results.error {
                completionHandler(error)
                
            } else if let data = results.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let characters = try decoder.decode([Character].self, from: data)
                    
                    var alives = characters.filter { $0.status == .alive }
                    var deads = characters.filter { $0.status == .dead }
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
                    
                    alives = alives.sorted(by: { dateFormatter.date(from:$0.created!)!.compare(dateFormatter.date(from:$1.created!)!) == .orderedDescending })
                    
                    deads = deads.sorted(by: { dateFormatter.date(from:$0.created!)!.compare(dateFormatter.date(from:$1.created!)!) == .orderedDescending })
                    
                    self.characters.append(deads)
                    self.characters.append(alives)
                    
                    completionHandler(nil)
                    
                }catch {
                    completionHandler(error)
                }
                
            }
        }
        
    }

    func getCharacterImage(character: Character, completion: @escaping (UIImage?) -> Void) {
        
        let imageURL = character.image!
        guard let url = URL(string: imageURL) else { return }
        
        rest.getData(fromURL: url) { (data) in
            
            if let data = data {
                guard let characterImage = UIImage(data: data) else {completion(nil); return}
                completion(characterImage)
            }
            
        }

    }
}
