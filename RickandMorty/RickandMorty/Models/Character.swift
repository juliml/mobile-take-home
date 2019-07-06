//
//  Character.swift
//  RickandMorty
//
//  Created by Juliana Lacerda on 2019-07-06.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import UIKit

/*
 id    int    The id of the character.
 name    string    The name of the character.
 status    string    The status of the character ('Alive', 'Dead' or 'unknown').
 species    string    The species of the character.
 type    string    The type or subspecies of the character.
 gender    string    The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
 origin    object    Name and link to the character's origin location.
 location    object    Name and link to the character's last known location endpoint.
 image    string (url)    Link to the character's image. All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
 episode    array (urls)    List of episodes in which this character appeared.
 url    string (url)    Link to the character's own URL endpoint.
 created    string    Time at which the character was created in the database.
 */

struct Character: Codable, CustomStringConvertible {
    var id: Int?
    var name: String?
    var status: StatusType?
    var species: String?
    var type: String?
    var gender: GenderType?
    var origin: SingleData?
    var location: SingleData?
    var image: String?
    var episode: [String]?
    var url: String?
    var created: String?
    
    var description: String {
        return """
        ------------
        id = \(id ?? -1)
        name = \(name ?? "")
        status = \(status ?? .unknown)
        species = \(species ?? "")
        type = \(type ?? "")
        gender = \(gender ?? .unknown)
        origin = \(origin ?? SingleData())
        location = \(location ?? SingleData())
        image = \(image ?? "")
        url = \(url ?? "")
        created = \(created ?? "")
        ------------
        """
    }
}

enum StatusType : String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

enum GenderType : String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

struct SingleData: Codable {
    var name: String = ""
    var url: String = ""

}

