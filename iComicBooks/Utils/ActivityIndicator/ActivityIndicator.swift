//
//  ActivityIndicator.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 26.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showActivityIndicator(atView view: UIView) -> UIView {
        let backgroundView = UIView.init(frame: view.bounds)
        backgroundView.backgroundColor?.withAlphaComponent(0.0)
        let indicator = UIActivityIndicatorView.init(style: .whiteLarge)
        indicator.center = backgroundView.center
        
        backgroundView.addSubview(indicator)
        view.addSubview(backgroundView)
        indicator.startAnimating()
        
        return backgroundView
    }
    
    func removeActivityIndicator(_ indicator: UIView) {
            indicator.removeFromSuperview()
    }
}
