import XCTest
import RealmSwift
@testable import university_listing

class MockNetworkService: NetworkServiceProtocol {
    var requestHandler: ((URL) -> (Result<Data, Error>))?
    
    func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        if let handler = requestHandler {
            completion(handler(url))
        }
    }
}

class UniversityListInteractorTests: XCTestCase {
    var interactor: UniversityInteractor!
    var mockPresenter: MockPresenter!
    var mockNetworkService: MockNetworkService!
    var testRealm: Realm!

    override func setUp() {
        super.setUp()
        
        mockNetworkService = MockNetworkService()
        
        // Create an in-memory Realm instance
        var config = Realm.Configuration()
        config.inMemoryIdentifier = "TestRealm"
        testRealm = try! Realm(configuration: config)
        
        interactor = UniversityInteractor(networkService: mockNetworkService, realm: testRealm)
        mockPresenter = MockPresenter()
        interactor.presenter = mockPresenter
    }

    override func tearDown() {
        super.tearDown()
        
        // Clean up in-memory Realm
        try! testRealm.write {
            testRealm.deleteAll()
        }
    }

    func testFetchUniversitiesSuccess() {
        let exp = expectation(description: "Fetch universities success")

        mockNetworkService.requestHandler = { url in
            let jsonString = """
            [{"web_pages": ["https://mbzuai.ac.ae/"], "country": "United Arab Emirates", "state-province": "Abu Dhabi", "domains": ["mbzuai.ac.ae"], "alpha_two_code": "AE", "name": "Mohamed bin Zayed University of Artificial Intelligence (MBZUAI)"}, {"web_pages": ["http://www.acd.ac.ae/"], "country": "United Arab Emirates", "state-province": null, "domains": ["acd.ac.ae"], "alpha_two_code": "AE", "name": "American College Of Dubai"}, {"web_pages": ["http://www.adu.ac.ae/"], "country": "United Arab Emirates", "state-province": null, "domains": ["adu.ac.ae"], "alpha_two_code": "AE", "name": "Abu Dhabi University"}, {"web_pages": ["http://www.agu.ae/"], "country": "United Arab Emirates", "state-province": null, "domains": ["agu.ae"], "alpha_two_code": "AE", "name": "Al Ghurair University"}]
            """.data(using: .utf8)!
            return .success(jsonString)
        }

        interactor.fetchUniversities()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockPresenter.isFetchSuccess)
            XCTAssertNotNil(self.mockPresenter.fetchedUniversities)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }

    func testFetchUniversitiesFailure() {
        let exp = expectation(description: "Fetch universities success")

        mockNetworkService.requestHandler = { url in
            return .failure(NSError(domain: "Test", code: 500, userInfo: nil))
        }
        interactor.fetchUniversities()
       // test still succeedss as data are fetched from the local realm
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.mockPresenter.isFetchSuccess)
            XCTAssertNotNil(self.mockPresenter.fetchedUniversities)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2.0)
    }
}

class MockPresenter: UniversityListPresenterProtocol {
    var router: UniversityListRouterProtocol?
    var interactor: UniversityListInteractorProtocol?
    var view: UniversityListViewProtocol?

    var isFetchSuccess = false
    var isFetchFailure = false
    var fetchedUniversities: [University]?
    var fetchError: Error?

    func InteractorDidFetchUniversities(with result: Result<[University], Error>) {
        switch result {
        case .success(let universities):
            isFetchSuccess = true
            fetchedUniversities = universities
        case .failure(let error):
            isFetchFailure = true
            fetchError = error
        }
    }

    func refreshUniversities() {}

    func navigateToUniversityDetail(university: University) {}
}
