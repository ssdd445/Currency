import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let currencyConversionStoryboard = UIStoryboard(name: "CurrencyConversion", bundle: nil)
        guard let currencyConversionViewController = currencyConversionStoryboard.instantiateViewController(withIdentifier: "CurrencyConversionViewController") as? CurrencyConversionViewController else {return}
        currencyConversionViewController.viewModel = CurrencyConversionViewModel(coordinator: self)
        navigationController.pushViewController(currencyConversionViewController, animated: false)
    }

    func navigateToDetailsScreen(currencies: String, conversions: ([String], [String])) {
        let currencyConversionStoryboard = UIStoryboard(name: "CurrencyHistory", bundle: nil)
        guard let currencyConversionViewController = currencyConversionStoryboard.instantiateViewController(withIdentifier: "CurrencyHistoryViewController") as? CurrencyHistoryViewController else {return}
        currencyConversionViewController.viewModel = CurrencyHistoryViewModel(currencies: currencies, conversions: conversions)
        navigationController.pushViewController(currencyConversionViewController, animated: false)

    }
}
