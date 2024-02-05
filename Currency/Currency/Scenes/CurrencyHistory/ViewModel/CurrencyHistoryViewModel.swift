//
//  CurrencyHistoryViewModel.swift
//  Currency
//
//  Created by Saud Temp on 04/02/2024.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyHistoryViewModel {
    
    var items: [History] = []
    /*History(success: true, timestamp: 123, historical: true, base: "GBP", date: "2024-02-02", rates: ["USD": 1.232,
     "GBP": 1.00,
     "EUR": 1.12]),
     History(success: true, timestamp: 1235, historical: true, base: "GBP", date: "2024-03-03", rates: ["USD": 1.232,
     "GBP": 1.023,
     "EUR": 1.121]),
     History(success: true, timestamp: 1235, historical: true, base: "GBP", date: "2024-04-04", rates: ["USD": 1.202,
     "GBP": 1.011,
     "EUR": 1.95])]*/
    private let currencies: String
    let isLoading = PublishSubject<Bool>()
    var reload: (() -> ())?
    
    init(currencies: String) {
        self.currencies = currencies
    }
    
    func getHistory() {
        for i in 1...3 {
            NetworkCalls.getHistoricalData(currencies: self.currencies,
                                           date: self.getThreePreviousDays(i) ?? "") { [weak self] result in
                switch result {
                case .success(let history):
                    self?.items.append(history)
                    self?.reload?()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getThreePreviousDays(_ num: Int)-> String? {
        let currentDate = Date()
        let calendar = Calendar.current
        if let threeDaysBack = calendar.date(byAdding: .day, value: -num, to: currentDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            let formattedDate = dateFormatter.string(from: threeDaysBack)
            return formattedDate
        } else {
            print("Error calculating the date")
            return nil
        }
    }
}
