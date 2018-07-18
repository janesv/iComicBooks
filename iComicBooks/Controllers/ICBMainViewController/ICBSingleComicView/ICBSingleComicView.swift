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
        
    override func awakeFromNib() {
        super.awakeFromNib()

        configureComicView()
    }
    
    // MARK: - comicView configurations
    
    fileprivate func configureComicView() {
        self.backgroundColor = UIColor.clear
        
        let comicImgViewFrame = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: self.frame.height)
        let comicImgView = UIImageView.init(frame: comicImgViewFrame)
        comicImgView.makeImageViewRoundedWithColoredFrame(color: .redComicViewFrameColor)
        self.addSubview(comicImgView)
    }
}
