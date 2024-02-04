import RxSwift
import RxCocoa
import Foundation

class CurrencyConversionViewModel {
    let buttonTap = PublishSubject<Void>()
    let isLoading = PublishSubject<Bool>()
    
    init() {
        setupBindings()
    }

    private func setupBindings() {

    }

    private let disposeBag = DisposeBag()
}
