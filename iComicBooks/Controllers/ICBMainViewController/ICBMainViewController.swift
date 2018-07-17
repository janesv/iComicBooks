//
//  ICBMainViewController.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 17.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit

/**
    ICBMainViewController - класс главного контроллера приложения.
*/

class ICBMainViewController: UIViewController {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var comicTitleLabel: UILabel!
    @IBOutlet var speechSynthesizerButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.backgroundColor = Colors.mainBackgroundColor
        configureComicTitleLabel(withText: "#1017 Valentine Dilemma")
    }
    
    func configureComicTitleLabel(withText text: String) {
        comicTitleLabel.textColor = UIColor.white
        comicTitleLabel.font = TextFonts.comingSoonRegularFontWithSize(size: 16)
        comicTitleLabel.textAlignment = .center
        comicTitleLabel.text = text
    }
}
