//
//  CurrencyHistoryViewController.swift
//  Currency
//
//  Created by Saud Temp on 04/02/2024.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyHistoryViewController: UIViewController {
    
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
        
        viewModel.isLoading
            .bind(to: loadingView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel.isLoading.subscribe({ event in
            self.view.isUserInteractionEnabled = !(event.element ?? false)
        }).disposed(by: disposeBag)
        
        self.registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.getHistory()
        self.viewModel.reload = { [weak self] in
            self?.tblViewHistoricalList.reloadData()
            self?.tblViewOtherCurrencies.reloadData()
        }
    }
    
    func registerTableViewCells() {
        tblViewHistoricalList.register(UINib(nibName: "HistoryTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "HistoryTableViewCell")
        tblViewOtherCurrencies.register(UINib(nibName: "ConversionTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "ConversionTableViewCell")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
            cell.configure(history: viewModel.items[indexPath.row])
            return cell
        case tblViewOtherCurrencies:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConversionTableViewCell", for: indexPath) as! ConversionTableViewCell
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
