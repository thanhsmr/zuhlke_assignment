//
//  BreedsWorker.swift
//  zuhlke_assignment
//

import Foundation

class BreedsWorker {
    private let networingManger = NetworkingManger.shared
    
    func fetchBreeds(completionHandler: @escaping (BreedAPIResponse) -> Void) {
        networingManger.performRequest(model: BreedAPIResponse.self, requestRouter: RequestsRouter.breed) { result in
            switch result {
            case .success(let model):
                completionHandler(model)
            case .failure(_):
                return
            }
        }
    }
    
    func fetchDogs(breed: String, page: Int, completionHandler: @escaping (DogAPIResponse) -> Void) {
        print("page", page)
        networingManger.performRequest(model: DogAPIResponse.self, requestRouter: RequestsRouter.dog(breed: breed)) { result in
            switch result {
            case .success(let model):
                if let items = model.message {
                    completionHandler(self.devideDogsByPageNumber(items: items, page: page))
                } else {
                    completionHandler(DogAPIResponse(message: []))
                }
            case .failure(_):
                return
            }
        }
    }
    
    private func devideDogsByPageNumber(items: [String], page: Int) -> DogAPIResponse {
        let totalCount = items.count
        let numberOfItemsOnPage = 10
        if (page * numberOfItemsOnPage) >= totalCount {
            //end of list
            let devidedModel = DogAPIResponse(message: [])
            return devidedModel
        } else {
            if totalCount < numberOfItemsOnPage {
                return DogAPIResponse(message: items)
            } else {
                let startOffset = page * numberOfItemsOnPage
                let endOffset = startOffset + numberOfItemsOnPage
                let devidedModel = DogAPIResponse(message: Array(items[startOffset..<endOffset]))
                return devidedModel
            }
            
        }
    }
}
