//
//  AlertController.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 26.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit

enum AlertType {
    case error
    case lastComicShown
    case firstComicShown
}

extension ICBMainViewController {
    func showAlert(type: AlertType) {
        var title = String()
        var message = String()
        
        switch type {
        case .error:
            title = "Error"
            message = "Oops... Something went wrong :("
        case .firstComicShown:
            title = "Oh!"
            message = "This is the first comic. There is no previous one 🤷‍♀️"
        case .lastComicShown:
            title = "Look!"
            message = "This is the last comic. No more fresh ones 😢"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
