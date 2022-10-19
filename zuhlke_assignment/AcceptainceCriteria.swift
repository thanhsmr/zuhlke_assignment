//
//  AcceptainceCriteria.swift
//  zuhlke_assignment
//

/*
 
View Controller:
 AC1: When view controller appears, should fetch breeds
 AC2: After viewModel update displayedBreeds should reload breed collectionview
 AC3: Number of items in collection should equal with number of fetched breed
 AC4: When select breed, should fetch dogs
 AC5: The first fetch dogs should with page 0
 AC5: The loadmore fetch dogs should with page 1
 
Interactor:
 AC1: When ViewController request Breds -> FetchBreeds should request worker to fetch breed and FetchBreeds should request presenter to present breed
 AC2: When ViewController request Dogs -> FetchBreeds should request worker to fetch dogs and FetchBreeds should request presenter to present dogs
 
Presenter:
 AC1: Presenter should request view controller to display breed after fetched breed request
 AC2: Presenter should request view controller to display dog after fetched dog request
 
 Worker:
  AC1: FetchBreeds should success when request API
 
 /**/*/
