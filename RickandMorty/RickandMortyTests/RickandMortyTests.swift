//
//  RickandMortyTests.swift
//  RickandMortyTests
//
//  Created by Juliana Lacerda on 2019-07-06.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import XCTest
@testable import RickandMorty

class RickandMortyTests: XCTestCase {

    func load(named name: String, ofType fileType: String = "json") -> Data? {
        let bundle = Bundle(for: RickandMortyTests.self)
        guard let url = bundle.url(forResource: name, withExtension: fileType)
            else {
                return nil
        }
        
        return try? Data(contentsOf: url)
    }
    
    func loadAndDecodeEpisodes(named name: String, ofType fileType: String = "json") -> [Episode]? {
        let bundle = Bundle(for: RickandMortyTests.self)
        guard let url = bundle.url(forResource: name, withExtension: fileType),
            let data = try? Data(contentsOf: url),
            let objectResponse = try? JSONDecoder().decode(ResultsEpisode.self, from: data)
            else {
                XCTFail("Unable to load and decode: \(name).\(fileType)")
                return nil
        }
        
        return objectResponse.results
    }
    
    func testEpisodesList() {
        guard let json = self.load(named: "Episodes")
            else {
                XCTFail("Could not load the json!")
                return
        }
        
        do {
            let decoder = JSONDecoder()
            let listResponse = try decoder.decode(ResultsEpisode.self, from: json)
            
            let info = listResponse.info
            
            XCTAssertEqual(info?.count, 2)
            XCTAssertEqual(info?.pages, 1)
            
            guard let firstEpisode = listResponse.results?.first
                else {
                    XCTFail("Unable to resolve the first Episode!")
                    return
            }
            
            XCTAssertEqual(firstEpisode.id, 1)
            XCTAssertEqual(firstEpisode.name, "Pilot")
            XCTAssertEqual(firstEpisode.episode, "S01E01")
            XCTAssertEqual(firstEpisode.url, "https://rickandmortyapi.com/api/episode/1")
        }
        catch {
            XCTFail("Could not decode the JSON! \(error)")
        }
    }


}
