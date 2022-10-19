//
//  Breed.swift
//  zuhlke_assignment
//

import Foundation

struct BreedAPIResponse: Decodable {
    var message: [String: [String]]?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case message, status
    }
}

struct DogAPIResponse: Codable {
    var message: [String]?
    var status: String?
}

