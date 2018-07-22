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
    It also contains methods to make comic view swipeable.
*/

class ICBMainViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var comicTitleLabel: UILabel!
    @IBOutlet var speechSynthesizerButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var comicView: ICBSingleComicView!
    @IBOutlet var backComicView: ICBSingleComicView!
    
    fileprivate var speechSynthButtonIsPressed = false
    fileprivate var comicViewInitialCenterPosition = CGPoint()
    fileprivate var movableComicView = UIView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.backgroundColor = .mainBackgroundColor

        reloadData()
        
        configureComicTitleLabel()
        configureButtons()
        configureComicView()
        
    }
    
    fileprivate func reloadData() {
        let apiClient = ICBAPIClient.shared()
        apiClient.getDataFrom(withParameters: "/2022") { (result) in
            switch result {
            case let .error(error):
                print(error)
                return
            case let .result(result):
                DispatchQueue.main.async {
                    self.comicTitleLabel.text = result.title
                    self.comicView.setImage(fromLink: result.img)
                    self.backComicView.setImage(fromLink: result.img)
                }
                return
            }
        }
    }
}

extension ICBMainViewController {
    
    // MARK: - Label configurations
    
    fileprivate func configureComicTitleLabel() {
        comicTitleLabel.textColor = UIColor.white
        comicTitleLabel.font = UIFont.comingSoonRegularFontWithSize(size: 18)
        comicTitleLabel.textAlignment = .center
    }
    
    // MARK: - Button configurations
    
    fileprivate func configureButtons() {
        configureButton(speechSynthesizerButton, withImage: ButtonImages.speechSynth.normalState)
        configureButton(shareButton, withImage: ButtonImages.share.normalState)
    }
    
    fileprivate func configureButton(_ button: UIButton, withImage image: UIImage) {
        button.setImage(image, for: .normal)
        
        if button == shareButton {
            button.addTarget(self, action: #selector(ICBMainViewController.shareButtonDidPress), for: .touchUpInside)
        } else if button == speechSynthesizerButton {
            button.addTarget(self, action: #selector(ICBMainViewController.speechSynthButtonDidPress), for: .touchUpInside)
        }
    }
    
    // MARK: Button press processing
    
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
    
    // MARK: - comicView configurations
    
    fileprivate func configureComicView() {
        comicViewInitialCenterPosition = comicView.center
        comicView.isUserInteractionEnabled = true
        addPanGestureRecognizer()
        addSwipeGestureRecognizer()
    }
    
    // MARK: - Gestures
    
    // MARK: Swipe gestures
    
    fileprivate func addSwipeGestureRecognizer() {
        [UISwipeGestureRecognizerDirection.left, .right].forEach({
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
            gesture.direction = $0
            self.view.addGestureRecognizer(gesture)
        })
    }
    
    @objc func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        var moveViewCenterPositionX = CGFloat()
        
        switch recognizer.direction {
        case .left:
            moveViewCenterPositionX = comicViewInitialCenterPosition.x + view.frame.width
        case .right:
            moveViewCenterPositionX = comicViewInitialCenterPosition.x - view.frame.width
        default:
            return
        }
        
        movableComicView.center.x = moveViewCenterPositionX
        addTiltAnimation(toView: movableComicView)
        UIView.animate(withDuration: 0.3, animations: { // Back to the initial position
            self.resetComicViewToInitialPosition(self.movableComicView)
        })
    }
    
    // MARK: Pan gestures
    
    fileprivate func addPanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture))
        comicView.addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        if let movableView = recognizer.view {
            movableComicView = movableView
            movableView.center = CGPoint(x: comicViewInitialCenterPosition.x + translation.x, y: comicViewInitialCenterPosition.y + translation.y)
            addTiltAnimation(toView: movableView)
            addSwipeGesture(recognizer, toView: movableView)
        }
    }
    
    fileprivate func addTiltAnimation(toView movableView: UIView) {
        let tiltAngle: CGFloat = 0.61 // 0.61 - radians expression for 35 degrees
        let distanceMoved = movableView.center.x - comicViewInitialCenterPosition.x
        let distanceShouldBeCovered = view.frame.size.width / tiltAngle
        let rotationAngle = distanceMoved / distanceShouldBeCovered
        
        movableView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        self.backComicView.alpha = abs(distanceMoved) / view.center.x // Add fade-in animation to view
    }
    
    /**
        Make view swipe-out of the screen.
        - parameter movableView: a view that would be swiped-out.
     */
    fileprivate func addSwipeGesture(_ recognizer: UIPanGestureRecognizer, toView movableView: UIView) {
        let recognizerState = recognizer.state
        switch recognizerState {
        case .ended:
            if movableView.center.x < 20.0 { // Swipe to the left
                UIView.animate(withDuration: 0.3, animations: {
                    movableView.center = CGPoint(x: movableView.center.x - self.view.frame.width, y: movableView.center.y)
                }, completion: {(true) in
                    self.resetComicViewToInitialPosition(movableView)
                })
                return
            } else if movableView.center.x > view.frame.width - 20.0 { // Swipe to the right
                UIView.animate(withDuration: 0.3, animations: {
                    movableView.center = CGPoint(x: movableView.center.x + self.view.frame.width, y: movableView.center.y)
                }, completion: {(true) in
                    self.resetComicViewToInitialPosition(movableView)
                })
                return
            }
            
            UIView.animate(withDuration: 0.2, animations: { // Back to the initial position
                self.resetComicViewToInitialPosition(movableView)
            })
        default:
            return
        }
    }
    
    fileprivate func resetComicViewToInitialPosition(_ view: UIView) {
        self.backComicView.alpha = 0.0
        view.center = self.comicViewInitialCenterPosition
        view.transform = .identity
    }
}
