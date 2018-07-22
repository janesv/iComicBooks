//
//  SpeechSynthesizer.swift
//  iComicBooks
//
//  Created by Sviridova Evgenia on 22.07.2018.
//  Copyright © 2018 Sviridova Evgenia. All rights reserved.
//

import Foundation
import AVFoundation

/**
    SpeechSynthesizer is a class that has methods for starting or stoping speaking directly.
 */

protocol SpeechSynthesizerDelegate {
    /**
        Method will be called every time a speech finishes.
     */
    func speechDidFinish()
}

class SpeechSynthesizer: NSObject {
    let synthesizer = AVSpeechSynthesizer()
    
    var delegate: SpeechSynthesizerDelegate!
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func startSpeaking(text: String) {
        var speechUtterance: AVSpeechUtterance
        
        if !text.isEmpty {
            speechUtterance = AVSpeechUtterance(string: text)
        } else {
            speechUtterance = AVSpeechUtterance(string: "No text for voice acting")
        }
        
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(speechUtterance)
    }
    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
}

extension SpeechSynthesizer: AVSpeechSynthesizerDelegate {
    internal func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.delegate.speechDidFinish()
    }
}
