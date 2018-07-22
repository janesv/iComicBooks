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
    func makeImageViewRoundedWithColoredBorders(color: UIColor) {
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

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        contentMode = mode
        self.clipsToBounds = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

