import XCTest
@testable import LunchFree

class SearchViewControllerTests: XCTestCase {
    var sut: SearchViewController!

    override func setUp() {
        super.setUp()
        sut = SearchViewController()
        sut.searchResultView = UITableView()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testUpdateSearchResultsFiltersByLunchSetName() {
        let item1 = restaurantlunchData(lunchSetName: "Tempura", restaurantName: "A", image: UIImage())
        let item2 = restaurantlunchData(lunchSetName: "Sushi", restaurantName: "B", image: UIImage())
        sut.dataList = [item1, item2]
        sut.searchController.searchBar.text = "Sushi"

        sut.updateSearchResults(for: sut.searchController)

        XCTAssertEqual(sut.searchResults.count, 1)
        XCTAssertEqual(sut.searchResults.first?.lunchSetName, "Sushi")
    }
}
