import RxSwift
import RxCocoa
import Foundation

class CurrencyConversionViewModel {
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
    
    private var toTextFieldValue = ""
    private var fromTextFieldValue = ""
    
    private let disposeBag = DisposeBag()
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fromTextField.accept("1")
        }
        setupBindings()
    }
    
    func temp() {
        self.isLoading.onNext(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading.onNext(false)
        }
    }
    
    private func setupBindings() {
        buttonFromTap.subscribe(onNext: { [weak self] in
            self?.isFromPickerVisible.accept(!(self?.isFromPickerVisible.value ?? false))
        }).disposed(by: disposeBag)
        
        buttonToTap.subscribe(onNext: { [weak self] in
            self?.isToPickerVisible.accept(!(self?.isToPickerVisible.value ?? false))
        }).disposed(by: disposeBag)
        
        buttonDoneTap.subscribe(onNext: { [weak self] in
            self?.isFromPickerVisible.accept(true)
            self?.isToPickerVisible.accept(true)
        }).disposed(by: disposeBag)
        
        buttonDetailsTap.subscribe(onNext: { [weak self] in
            print("\(#line)")
            self?.temp()
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
                                        from: self.selectedFromItem.value,
                                        to: self.selectedToItem.value,
                                        rates: self.ratesData.value?.rates) }
            .map { "\($0 ?? 0)" }
            .bind(to: toOutputSubject)
            .disposed(by: disposeBag)
        
        fromOutputSubject
            .subscribe(onNext: { result in
                print("From Result: \(result)")
            })
            .disposed(by: disposeBag)
        
        toOutputSubject
            .subscribe(onNext: { result in
                print("To Result: \(result)")
            })
            .disposed(by: disposeBag)
        
        selectFromItem
            .withLatestFrom(pickerFromData) { (index, items) -> String in
                return items[index]
            }
            .bind(to: selectedFromItem)
            .disposed(by: disposeBag)
        
        selectToItem
            .withLatestFrom(pickerToData) { (index, items) -> String in
                return items[index]
            }
            .bind(to: selectedToItem)
            .disposed(by: disposeBag)
    }
    
    private func convertCurrency(amount: Double,
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
        return (amount * conversionRate).rounded(toPlaces: 2)
    }
    
    func getHistory() {
        self.isLoading.onNext(true)
        NetworkCalls.getCurrencySymbolsData { [weak self] result in
            switch result {
            case .success(let symbols):
                self?.isLoading.onNext(false)
                print(symbols)
                self?.pickerFromData.accept(symbols.symbols.keys.map{$0})
                self?.pickerToData.accept(symbols.symbols.keys.map{$0})
            case .failure(let error):
                self?.isLoading.onNext(false)
                print(error.localizedDescription)
            }
        }
    }
    
    func getRates() {
        self.isLoading.onNext(true)
        NetworkCalls.getLatestCurrencyRates{ [weak self] result in
            switch result {
            case .success(let rates):
                self?.isLoading.onNext(false)
                self?.ratesData.accept(rates)
                print(rates)
            case .failure(let error):
                self?.isLoading.onNext(false)
                print(error.localizedDescription)
            }
        }
    }
}
