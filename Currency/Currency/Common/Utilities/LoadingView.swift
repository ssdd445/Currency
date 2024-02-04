import UIKit
import RxSwift
import RxCocoa

class LoadingView: UIView {
    var activityIndicator: UIActivityIndicatorView!
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupActivityIndicator()
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        layer.cornerRadius = 12
        backgroundColor = UIColor(white: 0, alpha: 0.4)
        isHidden = true
    }
    
    func bindToObservable(_ observable: Observable<Bool>) {
        observable
            .observe(on: MainScheduler.instance)
            .bind(to: rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
