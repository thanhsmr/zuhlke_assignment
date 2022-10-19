//
//  BreedsInteractorTests.swift
//  zuhlke_assignment
//

//

import XCTest
@testable import zuhlke_assignment

class BreedsWorkerTest: XCTestCase {

    var subject: BreedsWorker!
    
    override func setUp() {
        super.setUp()
        setupWorker()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    private func setupWorker() {
        subject = BreedsWorker()
    }
    
    func testFetchBreedShouldSuccess() {
        //Start
        var response: BreedAPIResponse?
        
        //When action
        let expect = expectation(description: "Wait for fetchBreeds() to return")
        subject.fetchBreeds { res in
            response = res
            expect.fulfill()
        }
        waitForExpectations(timeout: 1.1)

        //Check result
        XCTAssertEqual(response?.status, "success", "FetchBreeds should success when request API")
    }
    
}
