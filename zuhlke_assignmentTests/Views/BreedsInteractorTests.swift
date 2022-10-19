//
//  BreedsInteractorTests.swift
//  zuhlke_assignment
//

//

import XCTest
@testable import zuhlke_assignment

class BreedsInteractorTest: XCTestCase {

    var subject: BreedsInteractor!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        setupBreedsInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupBreedsInteractor() {
        subject = BreedsInteractor()
    }
    
    class BreedPresentationBusinessLogicSpy: BreedPresentationBusinessLogic {
        //Method call expectations
        var isPresentFetchedBreed = false
        var isPresentFetchedDog = false
        
        func presentFetchedDogs(response: Breeds.FetchDogs.Response) {
            isPresentFetchedDog = true
        }
        
        func presentFetchedBreeds(response: Breeds.FetchBreeds.Response) {
            isPresentFetchedBreed = true
        }
    }
    
    class BreedsWorkerSpy: BreedsWorker {
        var isFetchBreedCalled = false
        var isFetchDogCalled = false
        
        override func fetchBreeds(completionHandler: @escaping (BreedAPIResponse) -> Void) {
            isFetchBreedCalled = true
            completionHandler(BreedAPIResponse(message: ["affenpinscher": [], "african": []]))
        }
        
        override func fetchDogs(breed: String, page: Int, completionHandler: @escaping (DogAPIResponse) -> Void) {
            isFetchDogCalled = true
            completionHandler(
              DogAPIResponse(
                  message: ["https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg", "https://images.dog.ceo/breeds/hound-afghan/n02088094_1007.jpg"]))
        }
    }
    
    func testFetchBreedShouldRequestWorkerAndPresent() {
        //Start
        let breedPresentationBusinessLogicSpy = BreedPresentationBusinessLogicSpy()
        subject.presenter = breedPresentationBusinessLogicSpy
        let breedsWorkerSpy = BreedsWorkerSpy()
        subject.breedsWorker = breedsWorkerSpy
        
        //When action
        subject.fetchBreeds(request: Breeds.FetchBreeds.Request())
        
        //Check result
        XCTAssert(breedsWorkerSpy.isFetchBreedCalled, "FetchBreeds should request worker to fetch breeds")
        XCTAssert(breedPresentationBusinessLogicSpy.isPresentFetchedBreed, "FetchBreeds should request presenter to present breeds")
    }
    
    func testFetchDogsShouldRequestWorkerAndPresent() {
        //Start
        let breedPresentationBusinessLogicSpy = BreedPresentationBusinessLogicSpy()
        subject.presenter = breedPresentationBusinessLogicSpy
        let breedsWorkerSpy = BreedsWorkerSpy()
        subject.breedsWorker = breedsWorkerSpy
        
        //When action
        subject.fetchDogs(request: Breeds.FetchDogs.Request(breed: ""), page: 0)
        
        //Check result
        XCTAssert(breedsWorkerSpy.isFetchDogCalled, "FetchDogs should request worker to fetch order")
        XCTAssert(breedPresentationBusinessLogicSpy.isPresentFetchedDog, "FetchDogs should request presenter to present breed")
    }
    
}
