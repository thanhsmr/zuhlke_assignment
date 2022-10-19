//
//  BreedsInteractorTests.swift
//  zuhlke_assignment
//

//

import XCTest
@testable import zuhlke_assignment

class BreedsPresenterTests: XCTestCase {

    var subject: BreedPresentation!
    
    override func setUp() {
        super.setUp()
        setupBreedsPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupBreedsPresenter() {
        subject = BreedPresentation()
    }
    
    class BreedPresentationBusinessLogicSpy: BreedsDisplayBusinessLogic {
        //Method call expectations
        var isDisplayedFetchedBreed = false
        var isDisplayedFetchedDog = false
        
        func displayFetchedBreeds(viewModel: Breeds.FetchBreeds.ViewModel) {
            isDisplayedFetchedBreed = true
        }
        
        func displayFetchedDogs(viewModel: Breeds.FetchDogs.ViewModel) {
            isDisplayedFetchedDog = true
        }
    }
    
    func testWhenPresenterFetchedBreedShouldRequestViewControllerDisplayBreed() {
        //Start
        let breedPresentationBusinessLogicSpy = BreedPresentationBusinessLogicSpy()
        subject.viewController = breedPresentationBusinessLogicSpy
        
        //When action
        subject.presentFetchedBreeds(response: Breeds.FetchBreeds.Response(breedResponse: BreedAPIResponse(message: ["affenpinscher": [], "african": []])))
        
        //Check result
        XCTAssert(breedPresentationBusinessLogicSpy.isDisplayedFetchedBreed, "Presenter should request view controller display breed after fetched request")
    }
    
    func testWhenPresenterFetchedDogShouldRequestViewControllerDisplayDog() {
        //Start
        let breedPresentationBusinessLogicSpy = BreedPresentationBusinessLogicSpy()
        subject.viewController = breedPresentationBusinessLogicSpy
        
        //When action
        subject.presentFetchedDogs(response: Breeds.FetchDogs.Response(dogResponse: DogAPIResponse(
            message: ["https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg", "https://images.dog.ceo/breeds/hound-afghan/n02088094_1007.jpg"])))
        
        //Check result
        XCTAssert(breedPresentationBusinessLogicSpy.isDisplayedFetchedDog, "Presenter should request view controller display dog after fetched request")
    }
    
}
