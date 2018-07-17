//
//  ICBDesignConstantsFile.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 17.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import UIKit

/**
    Global constants file.
*/

// MARK: Colors

extension UIColor {
    static let mainBackgroundColor = UIColor(red: 0.11, green: 0.12, blue: 0.18, alpha: 1.0)
}

// MARK: Fonts

extension UIFont {
    static func comingSoonRegularFontWithSize(size: CGFloat) -> UIFont {
        return UIFont(name: "ComingSoon", size: size)!
    }
}

// MARK: Images

struct ButtonImages {
    struct speechSynth {
        static let normalState = #imageLiteral(resourceName: "speechSynthButtonIcon")
        static let pressedState = #imageLiteral(resourceName: "speechSynthPressedButtonIcon")
    }

    struct share {
        static let normalState = #imageLiteral(resourceName: "shareButtonIcon")
        static let pressedState = #imageLiteral(resourceName: "sharePressedButtonIcon")
    }
}

