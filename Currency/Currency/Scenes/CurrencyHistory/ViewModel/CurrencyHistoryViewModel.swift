import UIKit
import RxSwift
import RxCocoa

final class CurrencyHistoryViewModel {
    
    var items = [History]()
    private let currencies: String
    let conversions: ([String], [String])
    var fromCurrency: String
    let dispatchGroup = DispatchGroup()
    let isLoading = PublishSubject<Bool>()
    var reload: (() -> ())?
    var errorSubject = PublishSubject<Error>()
    
    init(currencies: String, conversions: ([String], [String])) {
        self.currencies = currencies
        self.fromCurrency = currencies.components(separatedBy: ",").first ?? ""
        self.conversions = conversions
    }
    
    func getHistory() {
        self.isLoading.onNext(true)
        for i in 1...3 {
            self.dispatchGroup.enter()
            NetworkCalls.getHistoricalData(currencies: self.currencies,
                                           date: self.getPreviousDay(i) ?? "") { [weak self] result in
                self?.isLoading.onNext(false)
                self?.dispatchGroup.leave()
                switch result {
                case .success(let history):
                    self?.items.append(history)
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.errorSubject.onNext(error)
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.reload?()
        }
    }
    
    internal func getPreviousDay(_ num: Int) -> String? {
        let currentDate = Date()
        let calendar = Calendar.current
        if let threeDaysBack = calendar.date(byAdding: .day, value: -num, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let formattedDate = dateFormatter.string(from: threeDaysBack)
            return formattedDate
        } else {
            errorSubject.onNext(MyError.customError(Constants.DateError))
            return nil
        }
    }
}
