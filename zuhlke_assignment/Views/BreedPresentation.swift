//
//  BreedPresentation.swift
//  zuhlke_assignment
//

//

import Foundation

protocol BreedPresentationBusinessLogic {
    func presentFetchedBreeds(response: Breeds.FetchBreeds.Response)
    func presentFetchedDogs(response: Breeds.FetchDogs.Response)
}

class BreedPresentation: BreedPresentationBusinessLogic {
    weak var viewController: BreedsDisplayBusinessLogic?
    func presentFetchedBreeds(response: Breeds.FetchBreeds.Response) {
        var displayedBreeds: [Breeds.FetchBreeds.ViewModel.DisplayedBreeds] = []
        if let breedDic = response.breedResponse.message {
            for (key, _) in breedDic {
                displayedBreeds.append(Breeds.FetchBreeds.ViewModel.DisplayedBreeds(name: key))
            }
        }
        let viewModel = Breeds.FetchBreeds.ViewModel(displayBreeds: displayedBreeds)
        viewController?.displayFetchedBreeds(viewModel: viewModel)
    }
    
    func presentFetchedDogs(response: Breeds.FetchDogs.Response) {
        var displayedDogs: [Breeds.FetchDogs.ViewModel.DisplayedDogs] = []
        if let dogs = response.dogResponse.message {
            for dog in dogs {
                displayedDogs.append(Breeds.FetchDogs.ViewModel.DisplayedDogs(imageURL: dog))
            }
        }
        let viewModel = Breeds.FetchDogs.ViewModel(displayDogs: displayedDogs)
        viewController?.displayFetchedDogs(viewModel: viewModel)
    }
}
