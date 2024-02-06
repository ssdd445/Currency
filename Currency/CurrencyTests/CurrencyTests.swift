import XCTest
@testable import Currency

final class CurrencyTests: XCTestCase {

    var currencyHistoryVM: CurrencyHistoryViewModel!
    var currencyConversionVM: CurrencyConversionViewModel!
    
    override func setUp() {
        super.setUp()
        currencyHistoryVM = CurrencyHistoryViewModel(currencies: "", conversions: ([], []))
        currencyConversionVM = CurrencyConversionViewModel(coordinator: MainCoordinator(navigationController: UINavigationController()))
    }
    
    override func tearDown() {
        currencyHistoryVM = nil
        currencyConversionVM = nil
        super.tearDown()
    }
    
    func testGetPreviousDay() {
        // Assuming today's date is 2024-02-06 and we want to get 3 days back.        
        let expectedResult = "2024-02-03" // Adjust this based on the current date
        if let result = currencyHistoryVM.getPreviousDay(3) {
            XCTAssertEqual(result, expectedResult, "The function did not return the expected previous date.")
        } else {
            XCTFail("The function returned nil.")
        }
    }
    
    func testGetPreviousDayWithNegativeInput() {
        let numDays = -3
        if let result = currencyHistoryVM.getPreviousDay(numDays) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let currentDate = dateFormatter.string(from: Date())
            
            XCTAssertNotEqual(result, currentDate, "The function should return a future date for negative input.")
        } else {
            XCTFail("The function returned nil for negative input.")
        }
    }

    func testConversionWithValidCurrencies() {
        let rates = ["USD": 1.0, "EUR": 0.85]
        let result = currencyConversionVM.convertCurrency(amount: 1, from: "USD", to: "EUR", rates: rates)
        XCTAssertEqual(result, 0.85, "Conversion from USD to EUR did not match expected value.")
    }
    
    func testConversionRoundedToFourPlaces() {
        let rates = ["USD": 1.0, "INR": 74.56789]
        let result = currencyConversionVM.convertCurrency(amount: 1, from: "USD", to: "INR", rates: rates)
        XCTAssertEqual(result, 74.5679, "Conversion from USD to INR did not round to four decimal places as expected.")
    }
    
    func testConversionWithUnknownSourceCurrency() {
        let rates = ["USD": 1.0, "EUR": 0.85]
        let result = currencyConversionVM.convertCurrency(amount: 1, from: "GBP", to: "EUR", rates: rates)
        XCTAssertNil(result, "Conversion with unknown source currency should return nil.")
    }
    
    func testConversionWithUnknownTargetCurrency() {
        let rates = ["USD": 1.0, "EUR": 0.85]
        let result = currencyConversionVM.convertCurrency(amount: 1, from: "USD", to: "GBP", rates: rates)
        XCTAssertNil(result, "Conversion with unknown target currency should return nil.")
    }
    
    func testConversionWithNilRates() {
        let result = currencyConversionVM.convertCurrency(amount: 1, from: "USD", to: "EUR", rates: nil)
        XCTAssertNil(result, "Conversion with nil rates should return nil.")
    }
}
