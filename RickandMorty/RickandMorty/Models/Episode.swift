//
//  Episode.swift
//  RickandMorty
//
//  Created by Juliana Lacerda on 2019-07-06.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

/*
 id    int    The id of the episode.
 name    string    The name of the episode.
 air_date    string    The air date of the episode.
 episode    string    The code of the episode.
 characters    array (urls)    List of characters who have been seen in the episode.
 url    string (url)    Link to the episode's own endpoint.
 created    string    Time at which the episode was created in the database.
 */

struct Episode: Codable, CustomStringConvertible {
    var id: Int?
    var name: String?
    var air_date: String?
    var episode: String?
    var characters: [String]?
    var url: String?
    var created: String?
    
    var description: String {
        var desc = """
        id = \(id ?? -1)
        name = \(name ?? "")
        air date = \(air_date ?? "")
        episode = \(episode ?? "")
        url = \(url ?? "")
        created = \(url ?? "")
        characters:
        
        """
        if let list = characters {
            for character in list {
                desc += character.description
            }
        }
        
        return desc
    }
}
