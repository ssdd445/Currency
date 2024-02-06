import UIKit
import RxSwift
import RxCocoa

class CurrencyHistoryViewController: BaseViewController {
    
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loadingView.center = view.center
        return loadingView
    }()
    
    @IBOutlet weak var tblViewHistoricalList: UITableView!
    @IBOutlet weak var tblViewOtherCurrencies: UITableView!
    
    var viewModel: CurrencyHistoryViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.registerTableViewCells()
        self.registerBindings()
    }
    
    private func registerBindings() {
        viewModel.isLoading
            .bind(to: loadingView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe({ event in
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = !(event.element ?? false)
            }
        }).disposed(by: disposeBag)
        
        
        self.viewModel.getHistory()
        self.viewModel.reload = { [weak self] in
            self?.tblViewHistoricalList.reloadData()
            self?.tblViewOtherCurrencies.reloadData()
        }
        
        self.viewModel.errorSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                DispatchQueue.main.async {
                    self?.showError(error)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func registerTableViewCells() {
        tblViewHistoricalList.register(UINib(nibName: Constants.HistoryTableViewCell, bundle: nil),
                                       forCellReuseIdentifier: Constants.HistoryTableViewCell)
        tblViewOtherCurrencies.register(UINib(nibName: Constants.ConversionTableViewCell, bundle: nil),
                                        forCellReuseIdentifier: Constants.ConversionTableViewCell)
    }
}

extension CurrencyHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblViewHistoricalList:
            return self.viewModel.items.count
        case tblViewOtherCurrencies:
            return self.viewModel.conversions.0.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tblViewHistoricalList:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.HistoryTableViewCell, for: indexPath) as! HistoryTableViewCell
            cell.configure(history: viewModel.items[indexPath.row])
            return cell
        case tblViewOtherCurrencies:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ConversionTableViewCell, for: indexPath) as! ConversionTableViewCell
            cell.configure(from: self.viewModel.fromCurrency,
                           to: self.viewModel.conversions.0[indexPath.row],
                           symbol: self.viewModel.conversions.1[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
