//
//  UIImageView+Additions.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 18.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit

/**
    UIImageView extentions.
*/

extension UIImageView {
    func makeImageViewRoundedWithColoredFrame(color: UIColor) {
        self.backgroundColor = color
        self.makeImageViewRounded(radius: 15.0)
        
        let contentImageViewFrame = CGRect(x: 10.0, y: 10.0, width: self.frame.width - 20.0, height: self.frame.height - 20.0)
        let contentImageView = UIImageView.init(frame: contentImageViewFrame)
        contentImageView.makeImageViewRounded(radius: 15.0)
        contentImageView.backgroundColor = .white
        
        self.addSubview(contentImageView)
    }
    
    func makeImageViewRounded(radius: CGFloat) {
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}
