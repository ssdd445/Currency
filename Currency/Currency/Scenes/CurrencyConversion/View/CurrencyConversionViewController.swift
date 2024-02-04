import UIKit
import RxSwift
import RxCocoa

class CurrencyConversionViewController: UIViewController {
    
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loadingView.center = view.center
        return loadingView
    }()
    
    @IBOutlet weak var buttonFrom: UIButton!
    @IBOutlet weak var buttonTo: UIButton!
    @IBOutlet weak var buttonSwap: UIButton!
    @IBOutlet weak var buttonDetail: UIButton!
    
    @IBOutlet weak var txtFieldFrom: CleanTextField!
    @IBOutlet weak var txtFieldTo: CleanTextField!

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
        
        buttonFrom.rx.tap
            .bind(to: viewModel.buttonFromTap)
            .disposed(by: disposeBag)
        
        buttonTo.rx.tap
            .bind(to: viewModel.buttonToTap)
            .disposed(by: disposeBag)
        
        buttonSwap.rx.tap
            .bind(to: viewModel.buttonSwapTap)
            .disposed(by: disposeBag)
        
        buttonDetail.rx.tap
            .bind(to: viewModel.buttonDetailsTap)
            .disposed(by: disposeBag)
        
        viewModel.fromTextField
            .bind(to: txtFieldFrom.rx.text)
            .disposed(by: disposeBag)
        
        txtFieldFrom.rx.text
            .orEmpty
            .map { String($0.prefix(Constants.textFieldLength)) }
            .bind(to: viewModel.fromTextField)
            .disposed(by: disposeBag)

        txtFieldTo.rx.text
            .orEmpty
            .map { String($0.prefix(Constants.textFieldLength)) }
            .bind(to: viewModel.toTextField)
            .disposed(by: disposeBag)

        viewModel.fromOutputSubject
            .bind(to: txtFieldTo.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.toOutputSubject
            .bind(to: txtFieldFrom.rx.text)
            .disposed(by: disposeBag)
    }
}
