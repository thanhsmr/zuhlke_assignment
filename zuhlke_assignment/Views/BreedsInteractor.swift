//
//  BreedsInteractor.swift
//  zuhlke_assignment
//

//

import Foundation

protocol BreedsBusinessLogic {
    func fetchBreeds(request: Breeds.FetchBreeds.Request)
    func fetchDogs(request: Breeds.FetchDogs.Request, page: Int)
}

protocol BreedsData {
    var breedResponse: BreedAPIResponse? {get}
}

protocol DogsData {
    var dogResponse: DogAPIResponse? {get}
}

class BreedsInteractor: BreedsBusinessLogic, BreedsData, DogsData {
    var presenter: BreedPresentationBusinessLogic?
    var breedsWorker = BreedsWorker()
    var dogResponse: DogAPIResponse?
    var breedResponse: BreedAPIResponse?
    
    func fetchBreeds(request: Breeds.FetchBreeds.Request) {
        breedsWorker.fetchBreeds { response in
            self.breedResponse = response
            let response = Breeds.FetchBreeds.Response(breedResponse: response)
            self.presenter?.presentFetchedBreeds(response: response)
        }
    }
    
    func fetchDogs(request: Breeds.FetchDogs.Request, page: Int) {
        breedsWorker.fetchDogs(breed: request.breed, page: page) { response in
            self.dogResponse = response
            let response = Breeds.FetchDogs.Response(dogResponse: response)
            self.presenter?.presentFetchedDogs(response: response)
        }
    }
    
}
