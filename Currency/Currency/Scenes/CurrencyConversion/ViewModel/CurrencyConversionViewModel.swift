import RxSwift
import RxCocoa
import Foundation
import UIKit

final class CurrencyConversionViewModel {
    let buttonFromTap = PublishSubject<Void>()
    let buttonToTap = PublishSubject<Void>()
    let buttonDoneTap = PublishSubject<Void>()
    let buttonDetailsTap = PublishSubject<Void>()
    let buttonSwapTap = PublishSubject<Void>()
    
    let fromTextField = BehaviorRelay(value: "1")
    let toTextField = BehaviorRelay(value: "")
    
    let fromOutputSubject = BehaviorRelay(value: "")
    let toOutputSubject = BehaviorRelay(value: "")
    
    let pickerFromData = BehaviorRelay<[String]>(value: [])
    let pickerToData = BehaviorRelay<[String]>(value: [])
    let ratesData = BehaviorRelay<Rate?>(value: nil)
    
    let selectedFromItem = BehaviorRelay<String>(value: "")
    let selectFromItem = PublishSubject<Int>()
    
    let selectedToItem = BehaviorRelay<String>(value: "")
    let selectToItem = PublishSubject<Int>()
    
    let isLoading = PublishSubject<Bool>()
    let isFromPickerVisible = BehaviorRelay<Bool>(value: true)
    let isToPickerVisible = BehaviorRelay<Bool>(value: true)
    
    var errorSubject = PublishSubject<Error>()
    let coordinator: MainCoordinator
    
    private let disposeBag = DisposeBag()
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fromTextField.accept("1")
        }
        setupBindings()
    }
    
    private func setupBindings() {
        buttonFromTap.subscribe(onNext: { [weak self] in
            self?.isToPickerVisible.accept(true)
            self?.isFromPickerVisible.accept(!(self?.isFromPickerVisible.value ?? false))
        }).disposed(by: disposeBag)
        
        buttonToTap.subscribe(onNext: { [weak self] in
            self?.isFromPickerVisible.accept(true)
            self?.isToPickerVisible.accept(!(self?.isToPickerVisible.value ?? false))
        }).disposed(by: disposeBag)
        
        buttonDoneTap.subscribe(onNext: { [weak self] in
            self?.isFromPickerVisible.accept(true)
            self?.isToPickerVisible.accept(true)
        }).disposed(by: disposeBag)
        
        buttonDetailsTap.subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            let from = selectedFromItem.value
            let to   = selectedToItem.value
            if ((!from.isEmpty) && (!to.isEmpty)) {
                coordinator.navigateToDetailsScreen(currencies: [from, to].joined(separator: ","), 
                                                    conversions: self.getTenConvertedValues())
            } else {
                self.errorSubject.onNext(MyError.customError(Constants.FieldsSelected))
            }
        }).disposed(by: disposeBag)
        
        buttonSwapTap.subscribe(onNext: { [weak self] in
            self?.fromTextField.accept(self?.fromOutputSubject.value ?? "1")
        }).disposed(by: disposeBag)
        
        fromTextField
            .compactMap { Double($0) ?? 1}
            .map { self.convertCurrency(amount: $0,
                                        from: self.selectedFromItem.value,
                                        to: self.selectedToItem.value,
                                        rates: self.ratesData.value?.rates) }
            .map { "\($0 ?? 0)" }
            .bind(to: fromOutputSubject)
            .disposed(by: disposeBag)
        
        toTextField
            .compactMap { Double($0) ?? 1 }
            .map { self.convertCurrency(amount: $0,
                                        from: self.selectedToItem.value,
                                        to: self.selectedFromItem.value,
                                        rates: self.ratesData.value?.rates) }
            .map { "\($0 ?? 0)" }
            .bind(to: toOutputSubject)
            .disposed(by: disposeBag)
        
        selectFromItem
            .withLatestFrom(pickerFromData) { (index, items) -> String in
                return items.isEmpty ? "" : items[index]
            }
            .bind(to: selectedFromItem)
            .disposed(by: disposeBag)
        
        selectToItem
            .withLatestFrom(pickerToData) { (index, items) -> String in
                return items.isEmpty ? "" : items[index]
            }
            .bind(to: selectedToItem)
            .disposed(by: disposeBag)
        
        selectToItem
            .subscribe(onNext: { [weak self] value in
                guard let self = self else {return}
                if (!self.selectedFromItem.value.isEmpty) {
                    self.fromTextField.accept(self.fromTextField.value)
                }
            }).disposed(by: disposeBag)
        
        selectFromItem
            .subscribe(onNext: { [weak self] value in
                guard let self = self else {return}
                if (!self.selectedFromItem.value.isEmpty) {
                    self.fromTextField.accept(self.fromTextField.value)
                }
            }).disposed(by: disposeBag)
    }
    
    internal func convertCurrency(amount: Double,
                                 from sourceCurrency: String,
                                 to targetCurrency: String,
                                 rates: [String: Double]?) -> Double? {
        guard let rates = rates,
              let sourceToBaseRate = rates[sourceCurrency],
              let targetToBaseRate = rates[targetCurrency] else {
            print("Rates for \(sourceCurrency) or \(targetCurrency) not found.")
            return nil
        }
        
        let conversionRate = targetToBaseRate / sourceToBaseRate
        return (amount * conversionRate).rounded(toPlaces: 4)
    }
    
    private func getTenConvertedValues() -> ([String], [String]) {
        var results = [String]()
        let currencies = Array(self.pickerFromData.value.prefix(11).filter{$0 != self.selectedFromItem.value}.prefix(10))
        for i in currencies {
            results.append("\(self.convertCurrency(amount: 1, from: self.selectedFromItem.value, to: i, rates: self.ratesData.value?.rates) ?? 0.0)")
        }
        return (results, currencies)
    }
    
    func getRates() {
        self.isLoading.onNext(true)
        NetworkCalls.getLatestCurrencyRates{ [weak self] result in
            self?.isLoading.onNext(false)
            switch result {
            case .success(let rates):
                DispatchQueue.main.async {
                    self?.ratesData.accept(rates)
                    self?.pickerFromData.accept(rates.rates.keys.map{$0})
                    self?.pickerToData.accept(rates.rates.keys.map{$0})
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorSubject.onNext(error)
                    print(error.localizedDescription)
                }
            }
        }
    }
}
