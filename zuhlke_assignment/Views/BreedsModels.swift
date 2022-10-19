//
//  BreedsModels.swift
//  zuhlke_assignment
//

//

import Foundation

enum Breeds {
    enum FetchBreeds {
        struct Request {}
        struct Response {
            var breedResponse: BreedAPIResponse
        }
        struct ViewModel {
            struct DisplayedBreeds {
                var name: String
            }
            var displayBreeds: [DisplayedBreeds]
        }
    }
    
    enum FetchDogs {
        struct Request {
            var breed: String
        }
        struct Response {
            var dogResponse: DogAPIResponse
        }
        struct ViewModel {
            struct DisplayedDogs {
                var imageURL: String
            }
            var displayDogs: [DisplayedDogs]
        }
    }
    
}
