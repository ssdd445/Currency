//
//  Reactive.swift
//  Currency
//
//  Created by Saud Temp on 04/02/2024.
//
import RxSwift
import RxCocoa
import Foundation

extension Reactive where Base: LoadingView {
    var isAnimating: Binder<Bool> {
        return Binder(self.base) { loadingView, isVisible in
            if isVisible {
                loadingView.isHidden = false
                loadingView.activityIndicator.startAnimating()
            } else {
                loadingView.isHidden = true
                loadingView.activityIndicator.stopAnimating()
            }
        }
    }
}
