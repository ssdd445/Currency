import RxSwift
import RxCocoa
import Foundation

class CurrencyConversionViewModel {
    let buttonFromTap = PublishSubject<Void>()
    let buttonToTap = PublishSubject<Void>()
    let buttonDetailsTap = PublishSubject<Void>()
    let buttonSwapTap = PublishSubject<Void>()
    
    let fromTextField = PublishSubject<String>()
    let toTextField = PublishSubject<String>()
    
//    let subject = BehaviorSubject<Int>(value: 10)
    let fromOutputSubject = PublishSubject<String>()
    let toOutputSubject = PublishSubject<String>()

//    let fromOutputSubject = PublishSubject<String>()
//    let toOutputSubject = PublishSubject<String>()
    
    private let disposeBag = DisposeBag()
    let isLoading = PublishSubject<Bool>()
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fromTextField.onNext("1")
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
            print("\(#line)")
            self?.temp()
        }).disposed(by: disposeBag)
        
        buttonToTap.subscribe(onNext: { [weak self] in
            print("\(#line)")
            self?.temp()
        }).disposed(by: disposeBag)
        
        buttonDetailsTap.subscribe(onNext: { [weak self] in
            print("\(#line)")
            self?.temp()
        }).disposed(by: disposeBag)
        
        buttonSwapTap.subscribe(onNext: { [weak self] in
            print("\(#line)")
            self?.temp()
        }).disposed(by: disposeBag)

        fromTextField
            .compactMap { Int($0) ?? 1}
            .map { $0 * 2 }
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
                print("To Result1: \(result)")
            })
            .disposed(by: disposeBag)
    }
}
