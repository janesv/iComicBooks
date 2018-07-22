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
        let comicImgView = UIImageView(frame: comicImgViewFrame)
        comicImgView.makeImageViewRoundedWithColoredBorders(color: .redComicViewBorderColor)
        self.addSubview(comicImgView)
        
    }
}

extension ICBSingleComicView {
    func setImage(fromLink link: String) {
        let imgView = self.subviews[0].subviews[0] as! UIImageView
        imgView.downloadedFrom(link: link)
    }
}
