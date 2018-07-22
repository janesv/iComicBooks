//
//  SpeechSynthesizerExtensions.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 22.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import AVFoundation

/**
    Extension for AVSpeechSynthesizer that has methods for starting or stoping speaking directly.
 */

extension AVSpeechSynthesizer {
    
    func startSpeaking(text: String) {
        var speechUtterance: AVSpeechUtterance
        
        if !text.isEmpty {
            speechUtterance = AVSpeechUtterance(string: text)
        } else {
            speechUtterance = AVSpeechUtterance(string: "No text for voice acting")
        }
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speak(speechUtterance)
    }
    
    func stopSpeaking() {
        stopSpeaking(at: AVSpeechBoundary.immediate)
    }
}
