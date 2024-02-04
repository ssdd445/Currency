import UIKit
import RxSwift
import RxCocoa

class CurrencyConversionViewController: UIViewController {
    
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loadingView.center = view.center
        return loadingView
    }()

    private let disposeBag = DisposeBag()
    
    var viewModel: CurrencyConversionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(loadingView)
        
        self.configureBindings()
    }
    
    private func configureBindings() {
        viewModel.isLoading
            .bind(to: loadingView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe({ event in
            self.view.isUserInteractionEnabled = !(event.element ?? false)
        }).disposed(by: disposeBag)
    }
}
