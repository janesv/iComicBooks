//
//  ICBMainViewController.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 17.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

/**
    ICBMainViewController is a main view controller class.
    It also contains methods to make comic view swipeable.
*/

/**
    Type of a loading comic.
*/
enum ComicLoadingType {
    case nextComic
    case previousComic
    case currentComic
    case randomComic
}

class ICBMainViewController: UIViewController, SpeechSynthesizerDelegate {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var comicTitleLabel: UILabel!
    @IBOutlet var speechSynthesizerButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    @IBOutlet var comicView: ICBSingleComicView!
    
    fileprivate var speechSynthButtonIsPressed = false
    fileprivate var comicViewInitialCenterPosition = CGPoint()
    fileprivate var textSpeechUtterance = String()
    fileprivate let speechSynthesizer = SpeechSynthesizer()
    fileprivate var currentComicId = String()
    fileprivate var lastComicId = Int()
    fileprivate var comics: [ICBComic] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.backgroundColor = .mainBackgroundColor
        speechSynthesizer.delegate = self
        becomeFirstResponder()
        
        show(.currentComic)
        
        configureComicTitleLabel()
        configureButtons()
        configureComicView()
    }
}

// MARK: - Load and setup data

fileprivate extension ICBMainViewController {
    /**
        Load data from API by comic id
     */
    func loadData(comicId: String) {
        let apiClient = ICBAPIClient.shared()
        apiClient.getDataFrom(withParameters: comicId) { (result) in
            switch result {
            case let .error(error):
                print(error)
                return
            case let .result(result):
                DispatchQueue.main.async {
                    self.comicTitleLabel.text = "#\(result.num) \(result.title)"
                    self.comicView.setImage(fromLink: result.img)
                    self.textSpeechUtterance = result.transcript!
                    self.comics.append(result)
                    self.lastComicId = result.num
                    self.comicView.changeBorderColor()
                }
                return
            }
        }
    }
    
    /**
        Show neсessery comic
     */
    func show(_ comicQueue: ComicLoadingType) {
        var comicIdString = String()
        switch comicQueue {
        case .currentComic:
            comicIdString = ""
        case .nextComic:
            comicIdString = "/\(lastComicId + 1)"
        case .previousComic:
            comicIdString = "/\(lastComicId - 1)"
        case .randomComic:
            let randomComicId = Int(arc4random_uniform(42)) + 1
            comicIdString = "/\(randomComicId)"
        }
        loadData(comicId: comicIdString)
    }
}

// MARK: - Configuration

fileprivate extension ICBMainViewController {
    
    // MARK: Label configurations
    
    fileprivate func configureComicTitleLabel() {
        comicTitleLabel.textColor = UIColor.white
        comicTitleLabel.font = UIFont.comingSoonRegularFontWithSize(size: 18)
        comicTitleLabel.textAlignment = .center
    }
    
    // MARK: Button configurations
    
    fileprivate func configureButtons() {
        configureButton(speechSynthesizerButton, withImage: ButtonImages.speechSynth.normalState)
        configureButton(shareButton, withImage: ButtonImages.share.normalState)
    }
    
    fileprivate func configureButton(_ button: UIButton, withImage image: UIImage) {
        button.setImage(image, for: .normal)
        
        if button == shareButton {
            button.setImage(ButtonImages.share.pressedState, for: .highlighted)
            button.addTarget(self, action: #selector(ICBMainViewController.shareButtonDidPress), for: .touchUpInside)
        } else if button == speechSynthesizerButton {
            button.addTarget(self, action: #selector(ICBMainViewController.speechSynthButtonDidPress), for: .touchUpInside)
        }
    }
    
    // MARK: - comicView configurations
    
    fileprivate func configureComicView() {
        comicViewInitialCenterPosition = comicView.center
        comicView.isUserInteractionEnabled = true
        addPanGestureRecognizer()
        addSwipeGestureRecognizer()
    }
}

// MARK: - Button press processing

extension ICBMainViewController {
    
    // MARK: Share comic
    
    @objc fileprivate func shareButtonDidPress() {
        let activityShareVC = UIActivityViewController(activityItems: [comics.last!.img], applicationActivities: nil)
        self.present(activityShareVC, animated: true, completion: nil)
    }
    
    // MARK: Speech synthesizer
    
    @objc fileprivate func speechSynthButtonDidPress() {
        if speechSynthButtonIsPressed {
            speechDidFinish()
            speechSynthesizer.stopSpeaking()
            return
        }
        
        speechSynthesizerButton.setImage(ButtonImages.speechSynth.pressedState, for: .normal)
        speechSynthButtonIsPressed = true
        speechSynthesizer.startSpeaking(text: textSpeechUtterance)
    }
    
    func speechDidFinish() {
        speechSynthesizerButton.setImage(ButtonImages.speechSynth.normalState, for: .normal)
        speechSynthButtonIsPressed = false
    }
}

// MARK: - Gestures

extension ICBMainViewController {
    // MARK: Shake gesture
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            show(.randomComic)
        }
    }

    // MARK: Swipe gesture
    
    fileprivate func addSwipeGestureRecognizer() {
        [UISwipeGestureRecognizerDirection.left, .right].forEach({
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
            gesture.direction = $0
            self.view.addGestureRecognizer(gesture)
        })
    }
    
    @objc func handleSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        var comicViewCenterPosX = comicViewInitialCenterPosition.x
        var comicViewInversePosX = comicViewCenterPosX
        var comicLoadingType: ComicLoadingType
        
        switch recognizer.direction {
        case .right:
            if lastComicId >= comics.first!.num {
                return
            }
            comicViewCenterPosX += 2 * view.frame.width
            comicViewInversePosX -= 2 * view.frame.width
            comicLoadingType = .nextComic
        case .left:
            if lastComicId <= 1 {
                return
            }
            comicViewCenterPosX -= 2 * view.frame.width
            comicViewInversePosX += 2 * view.frame.width
            comicLoadingType = .previousComic
        default:
            return
        }
        
        let recognizerState = recognizer.state
        switch recognizerState {
        case .ended:
            comicView.center = comicViewInitialCenterPosition
            UIView.animate(withDuration: 0.4, animations: {
                self.comicView.center = CGPoint(x: comicViewCenterPosX, y: self.comicViewInitialCenterPosition.x / 2.0)
                self.addTiltAnimation(toView: self.comicView)
            }, completion: {(true) in
                self.show(comicLoadingType)
                self.comicView.center = CGPoint(x: comicViewInversePosX, y: self.comicView.center.y - self.comicViewInitialCenterPosition.x / 2.0)
                self.resetViewToInitialPosition(self.comicView, withDuration: 0.3)
            })
        default:
            return
        }
    }
    
    // MARK: Pan gesture
    
    fileprivate func addPanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture))
        comicView.addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        if let movableView = recognizer.view {
            movableView.center = CGPoint(x: comicViewInitialCenterPosition.x + translation.x, y: comicViewInitialCenterPosition.y + translation.y)
            addTiltAnimation(toView: movableView)
            addSwipeOutGesture(recognizer, toView: movableView)
        }
    }
    
    fileprivate func addTiltAnimation(toView movableView: UIView) {
        let tiltAngle: CGFloat = 0.61 // 0.61 - radians expression for 35 degrees
        let distanceMoved = movableView.center.x - comicViewInitialCenterPosition.x
        let distanceShouldBeCovered = view.frame.size.width / tiltAngle
        let rotationAngle = distanceMoved / distanceShouldBeCovered
        
        movableView.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    /**
        Swipe-out a given view of the screen.
        - parameter movableView: a view that would be swiped-out.
     */
    fileprivate func addSwipeOutGesture(_ recognizer: UIPanGestureRecognizer, toView movableView: UIView) {
        let recognizerState = recognizer.state
        switch recognizerState {
        case .ended:
            if movableView.center.x < 20.0 { // Swipe to the left
                
                if lastComicId <= 1 {
                    resetViewToInitialPosition(movableView, withDuration: 0.2)
                    return
                }
                
                UIView.animate(withDuration: 0.3, animations: {
                    movableView.center = CGPoint(x: movableView.center.x - self.view.frame.width, y: movableView.center.y)
                }, completion: {(true) in
                    self.show(.previousComic)
                })
                
                movableView.center = CGPoint(x: movableView.center.x + 2 * self.view.frame.width, y: movableView.center.y)
                resetViewToInitialPosition(movableView, withDuration: 0.4)

                return
            } else if movableView.center.x > view.frame.width - 20.0 { // Swipe to the right

                if lastComicId >= comics.first!.num {
                    resetViewToInitialPosition(movableView, withDuration: 0.2)
                    return
                }
                
                UIView.animate(withDuration: 0.3, animations: {
                    movableView.center = CGPoint(x: movableView.center.x + self.view.frame.width, y: movableView.center.y)
                }, completion: {(true) in
                    self.show(.nextComic)
                })
                movableView.center = CGPoint(x: movableView.center.x - 2 * self.view.frame.width, y: movableView.center.y)
                resetViewToInitialPosition(movableView, withDuration: 0.4)

                return
            }
            
            resetViewToInitialPosition(movableView, withDuration: 0.2)
        default:
            return
        }
    }
    
    /**
        Reset given view to initial position of comic view using the specified duration
     */
    fileprivate func resetViewToInitialPosition(_ view: UIView, withDuration duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            view.center = self.comicViewInitialCenterPosition
            view.transform = .identity
        })
    }
}
