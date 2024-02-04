//
//  AppDelegate.swift
//  Currency
//
//  Created by Saud Temp on 04/02/2024.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let currencyConversionStoryboard = UIStoryboard(name: "CurrencyConversion", bundle: nil)
        guard let currencyConversionViewController = currencyConversionStoryboard.instantiateViewController(withIdentifier: "CurrencyConversionViewController") as? CurrencyConversionViewController else {return true}
        currencyConversionViewController.viewModel = CurrencyConversionViewModel()
        let navigation = UINavigationController(rootViewController: currencyConversionViewController)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
}
