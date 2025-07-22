//
//  BaseViewController.swift
//  EterationCase
//
//  Created by Abdullah Onur Şimşek on 21.07.2025.
//

import UIKit

class BaseViewController: UIViewController {
    private var isShown: Bool = false
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                         width: 40, height: 40))
        view.style = UIActivityIndicatorView.Style.large
        view.color = .baseGray
        view.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                              y: UIScreen.main.bounds.height / 2)
        view.layer.zPosition = 10
        return view
    }()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    func showProgressHUD() {
        if !isShown {
            isShown = true
            view.addSubview(indicator)
            view.bringSubviewToFront(indicator)
            indicator.startAnimating()
        }
        
    }

    func hideProgressHUD() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicator.stopAnimating()
            self.indicator.removeFromSuperview()
            self.isShown = false
        }
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func showSimpleAlert(with message: String) {
        let alertContoller = UIAlertController(title: "Error",
                                               message: message,
                                               preferredStyle: .alert)
        alertContoller.addAction(UIAlertAction(title: "Ok",
                                               style: .default,
                                               handler: nil))
        DispatchQueue.main.async {
            self.present(alertContoller, animated: true)

        }
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

