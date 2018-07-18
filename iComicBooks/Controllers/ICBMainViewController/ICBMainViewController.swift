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
    ICBMainViewController is a main view controller class.
*/

class ICBMainViewController: UIViewController {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var comicTitleLabel: UILabel!
    @IBOutlet var speechSynthesizerButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var comicView: ICBSingleComicView!
    
    private var speechSynthButtonIsPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.backgroundColor = .mainBackgroundColor
        
        configureComicTitleLabel(withText: "#1017 Valentine Dilemma")
        configureButtons()
    }
    
    // MARK: - Title configurations
    
    private func configureComicTitleLabel(withText text: String) {
        comicTitleLabel.textColor = UIColor.white
        comicTitleLabel.font = UIFont.comingSoonRegularFontWithSize(size: 18)
        comicTitleLabel.textAlignment = .center
        comicTitleLabel.text = text
    }
    
    // MARK: - Button configurations
    
    private func configureButtons() {
        configureButton(speechSynthesizerButton, withImage: ButtonImages.speechSynth.normalState)
        configureButton(shareButton, withImage: ButtonImages.share.normalState)
    }
    
    private func configureButton(_ button: UIButton, withImage image: UIImage) {
        button.setImage(image, for: .normal)
        
        if button == shareButton {
            button.addTarget(self, action: #selector(ICBMainViewController.shareButtonDidPress), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(ICBMainViewController.speechSynthButtonDidPress), for: .touchUpInside)
        }
    }
    
    // MARK: - Button press processing
    
    @objc fileprivate func shareButtonDidPress() {
        
    }
    
    @objc fileprivate func speechSynthButtonDidPress() {
        if speechSynthButtonIsPressed {
            speechSynthesizerButton.setImage(ButtonImages.speechSynth.normalState, for: .normal)
            speechSynthButtonIsPressed = false
        } else {
            speechSynthesizerButton.setImage(ButtonImages.speechSynth.pressedState, for: .normal)
            speechSynthButtonIsPressed = true
        }
    }
}
