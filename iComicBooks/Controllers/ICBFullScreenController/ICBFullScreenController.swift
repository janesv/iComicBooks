//
//  ICBFullScreenController.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 26.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import ImageSlideshow

class ICBFullScreenController: FullScreenSlideshowViewController {
    
    fileprivate var slideshowTransitioningDelegate: ZoomAnimatedTransitioningDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundColor = .white
        self.slideshow.backgroundColor = .white
        self.closeButton.setImage(ButtonImages.fullScreenClose, for: .normal)
    }
    
    func configure(withView view: ICBSingleComicView) {
        let comicImageView = view.subviews[0].subviews[0] as? UIImageView
        self.inputs = [ImageSource(image: (comicImageView?.image!)!)]
        
        if let imageView = comicImageView {
            slideshowTransitioningDelegate = ZoomAnimatedTransitioningDelegate(imageView: imageView, slideshowController: self)
            self.transitioningDelegate = slideshowTransitioningDelegate
        }
    }
}
