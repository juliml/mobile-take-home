//
//  EpisodesViewModel.swift
//  RickandMorty
//
//  Created by Juliana Lacerda on 2019-07-06.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

class EpisodesViewModel: NSObject {

    let rest = RestManager()
    
    var dataResults: ResultsEpisode?
    var episodes: [Episode] = []
    
    let url = "https://rickandmortyapi.com/api/episode"
    
    func numberOfRows() -> Int{
        return episodes.count
    }
    
    func getEpisodeResponseBy(index: Int) -> Episode? {
        return episodes[index]
    }
    
    func hasNextPage() -> String? {
        if let nextPage = self.dataResults?.info?.next {
            return nextPage
        }
        
        return nil
    }
    
    func getAllEpisodes(firstPage: Bool, completionHandler: @escaping (Error?) -> Void) {
        
        var currentUrl: String = self.url
        if firstPage == false {
            if let nextUrl: String = self.hasNextPage() {
                currentUrl = nextUrl
            }
        }
        
        guard let url = URL(string: currentUrl) else { return }
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            
            if let error = results.error {
                completionHandler(error)
                
            } else if let data = results.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    self.dataResults = try decoder.decode(ResultsEpisode.self, from: data)
                    
                    if (firstPage == true) {
                        self.episodes = (self.dataResults?.results)!
                    } else {
                        self.episodes += (self.dataResults?.results)!
                    }
                    
                    completionHandler(nil)
                }catch {
                    completionHandler(error)
                }
            
            }
        }
        
    }
    
}
