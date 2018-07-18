//
//  ICBSingleComicView.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 18.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit

/**
    ICBSingleComicView is a class that draws and configures a view
    for a single comic. It also contains methods to make this very view swipeable.
*/

class ICBSingleComicView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureComicView()
        addPanGestureRecognizer()
    }
    
    // MARK: - comicView configurations
    
    private func configureComicView() {
        self.backgroundColor = UIColor.clear
        
        let comicImgViewFrame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        let comicImgView = UIImageView.init(frame: comicImgViewFrame)
        comicImgView.makeImageViewRoundedWithColoredFrame(color: .redComicViewFrameColor)
        self.addSubview(comicImgView)
    }
    
    // MARK: - Gestures
    
    private func addPanGestureRecognizer() {
        self.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        if let myView = recognizer.view {
            myView.center = CGPoint(x: myView.center.x + translation.x, y: myView.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
    }
}
