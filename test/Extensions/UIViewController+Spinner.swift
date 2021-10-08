//
//  ViewController.swift
//  test
//
//  Created by Amalio Velasquez on 21/09/21.
//

import UIKit

fileprivate var overlay: UIView?

extension UIViewController {
    func showSpinner() {
        overlay = UIView(frame: view.bounds)
        overlay!.backgroundColor = UIColor(white: 0, alpha: 0.7)
        overlay!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let spinner = UIActivityIndicatorView(style: .whiteLarge)
        spinner.color = .green
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        overlay!.addSubview(spinner)
        view.addSubview(overlay!)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: overlay!.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: overlay!.centerYAnchor),
        ])
    }
    
    func removeSpinner() {
        overlay?.removeFromSuperview()
        overlay = nil
    }
    
    func isSpinnerVisible() -> Bool {
        return overlay != nil
    }
}
