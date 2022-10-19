//
//  BreedsViewControllerTest.swift
//  zuhlke_assignment
//

//

import XCTest
@testable import zuhlke_assignment

class BreedsViewControllerTest: XCTestCase {

    var subject: BreedsViewController!
    var window: UIWindow!
    
    override func setUp() {
        super.setUp()
        window = UIWindow()
        setupBreedsViewController()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    private func setupBreedsViewController() {
        subject = BreedsViewController.init(nibName: "BreedsViewController", bundle: nil)
    }
    
    private func loadView() {
        window.addSubview(subject.view)
    }
    
    class BreedsBusinessLogicSpy: BreedsBusinessLogic {
        
        //Method call expectations
        var isFetchBreedCalled = false
        var isFetchDogCalled = false
        var dogPageCalled = -1
        //Spied methods
        func fetchBreeds(request: Breeds.FetchBreeds.Request) {
            isFetchBreedCalled = true
        }
        func fetchDogs(request: Breeds.FetchDogs.Request, page: Int) {
            isFetchDogCalled = true
            dogPageCalled = page
        }
    }
    
    class CollectionViewSpy: UICollectionView {
        
        //Method call expectations
        var isReloadDataCalled = false
        //Spied methods
        override func reloadData() {
            isReloadDataCalled = true
        }
    }
    
    class TableViewSpy: UITableView {
        
        //Method call expectations
        var isReloadDataCalled = false
        //Spied methods
        override func reloadData() {
            isReloadDataCalled = true
        }
    }
    
    func testShouldFetchBreedsWhenViewDidAppear() {
        //Start view
        let breedsBusinessLogicSpy = BreedsBusinessLogicSpy()
        subject.interactor = breedsBusinessLogicSpy
        loadView()
        
        //When action
        subject.viewDidAppear(true)
        
        //Check result
        XCTAssert(breedsBusinessLogicSpy.isFetchBreedCalled, "When view appears, should fetch breeds")
    }
    
    func testShouldDisplayFetchedBreed() {
        //Start view
        let collectionViewSpy = CollectionViewSpy(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        subject.breedsCollectionView = collectionViewSpy
        
        //When action
        let displayedBreeds = [Breeds.FetchBreeds.ViewModel.DisplayedBreeds(name: "name 1")]
        let viewModel = Breeds.FetchBreeds.ViewModel(displayBreeds: displayedBreeds)
        subject.displayFetchedBreeds(viewModel: viewModel)
        
        //Check result
        XCTAssert(collectionViewSpy.isReloadDataCalled, "After viewModel update displayedBreeds should reload breed collectionview")
    }
    
    func testNumberOfItemInCollectionViewShouldEqualNumberOfFetchedBreed() {
        //Start view
        let collectionViewSpy = CollectionViewSpy(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let testDisplayedBreeds = [Breeds.FetchBreeds.ViewModel.DisplayedBreeds(name: "name 1")]
        subject.displayedBreeds = testDisplayedBreeds
        
        //When action
        let numberOfItem = subject.collectionView(collectionViewSpy, numberOfItemsInSection: 0)
        
        //Check result
        XCTAssertEqual(numberOfItem, testDisplayedBreeds.count, file: "number of items in collection should equal with number of fetched breed")
    }
    
    func testShouldFetchDogsWhenSelectBreed() {
        //Start view
        let breedsBusinessLogicSpy = BreedsBusinessLogicSpy()
        subject.interactor = breedsBusinessLogicSpy
        
        let collectionViewSpy = CollectionViewSpy(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        let testDisplayedBreeds = [Breeds.FetchBreeds.ViewModel.DisplayedBreeds(name: "name 1")]
        subject.displayedBreeds = testDisplayedBreeds
        
        //When action
        subject.collectionView(collectionViewSpy, didSelectItemAt: IndexPath.init(row: 0, section: 0))
        
        //Check result
        XCTAssert(breedsBusinessLogicSpy.isFetchDogCalled, "When select breed, should fetch dogs")
        XCTAssertEqual(breedsBusinessLogicSpy.dogPageCalled, 0, "the first fetch dogs should with page 0")
    }
    
    func testShouldFetchDogsWithLoadMoreWhenScrollToBottom() {
//        //Start view
//        let breedsBusinessLogicSpy = BreedsBusinessLogicSpy()
//        subject.interactor = breedsBusinessLogicSpy
//
//        let collectionViewSpy = CollectionViewSpy(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
//        let testDisplayedBreeds = [Breeds.FetchBreeds.ViewModel.DisplayedBreeds(name: "african")]
//        subject.displayedBreeds = testDisplayedBreeds
//
//        let tableViewSpy = TableViewSpy()
//        subject.dogsTableView = tableViewSpy
//        let testDisplayedDogs = [Breeds.FetchDogs.ViewModel.DisplayedDogs(imageURL: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg"), Breeds.FetchDogs.ViewModel.DisplayedDogs(imageURL: "https://images.dog.ceo/breeds/hound-afghan/n02088094_1003.jpg")]
//        subject.displayFetchedDogs(viewModel: Breeds.FetchDogs.ViewModel(displayDogs: testDisplayedDogs))
//
//
//        //When action
//        subject.collectionView(collectionViewSpy, didSelectItemAt: IndexPath.init(row: 0, section: 0))
//        subject.willdis
//
//        //Check result
//        XCTAssertEqual(breedsBusinessLogicSpy.dogPageCalled, 1, "fetch dogs should load more with page 1")
    }

}
