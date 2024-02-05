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

    let pickerFromData = BehaviorRelay<[String]>(value: ["Item 1", "Item 2", "Item 3"])
    let pickerToData = BehaviorRelay<[String]>(value: ["Item 1", "Item 2", "Item 3"])
    let selectedFromItem = PublishSubject<String>()
    let selectFromItem = PublishSubject<Int>()
    
    let selectedToItem = PublishSubject<String>()
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
            .compactMap { Int($0) ?? 1}
            .map { $0 * 3 }
            .map { "\($0)" }
            .bind(to: fromOutputSubject)
            .disposed(by: disposeBag)
        
        toTextField
            .compactMap { Int($0) ?? 1 }
            .map { $0 * 2 }
            .map { "\($0)" }
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
}
