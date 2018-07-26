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
    for a single comic. 
*/

class ICBSingleComicView: UIView {
    
    fileprivate var borderColorArray: [UIColor] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderColorArray = [UIColor.comicViewBorderColor.red,
                            UIColor.comicViewBorderColor.yellow,
                            UIColor.comicViewBorderColor.blue]
        
        configureComicView()
    }
    
    // MARK: - comicView configurations
    
    fileprivate func configureComicView() {
        self.backgroundColor = UIColor.clear
        
        let comicImgViewFrame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        let comicImgView = UIImageView(frame: comicImgViewFrame)
        comicImgView.makeImageViewRoundedWithColoredBorders()
        self.addSubview(comicImgView)
    }
}

extension ICBSingleComicView {
    /**
        Set image to ICBSingleComicView downloaded via given link
     */
    func setImage(fromLink link: String) {
        let imgView = self.subviews[0].subviews[0] as! UIImageView
        imgView.downloadImage(from: link)
    }
    
    /**
        Change border color of ICBSingleComicView.
        Color will be chosen randomically from array of border colors
     */
    func changeBorderColor() {
        let randomIndex = Int(arc4random_uniform(3))
        let randomColor = borderColorArray[randomIndex]
        self.subviews[0].backgroundColor = randomColor
    }
}
