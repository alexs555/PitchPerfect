//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Алексей Шпирко on 07/06/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    private enum Effects {
        case Reverb, Echo, Chipmonk, DartVader, Slow, Quick
    }
    private var audioEngine: SoundsEngine!
    
    var receivedAudio:RecorderedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Facade for audio effects
        audioEngine = SoundsEngine(filePathUrl:receivedAudio.filePathUrl!)

    }

// MARK: - IBActions
    
    @IBAction func playSoundSlowly(sender: UIButton) {
        playEffect(.Slow, value: 0.5)
    }
    
    @IBAction func playSoundFast(sender: UIButton) {
        playEffect(.Quick, value: 1.5)
    }
    
    @IBAction func chipmonkBtnPressed(sender: UIButton) {
        playEffect(.Chipmonk, value: 1000)
    }
    
    @IBAction func playDatrVaderEffect(sender: UIButton) {
        playEffect(.DartVader, value: -1000)
    }
    
    @IBAction func playReverberation(sender: UIButton) {
        playEffect(.Reverb, value: -50)
    }
    
    @IBAction func playEcho(sender: UIButton) {
        playEffect(.Echo, value: 40)
    }
  
    @IBAction func stopPlayingAudio(sender: UIButton) {
        audioEngine.stopPlaying()
    }
    
    
// MARK: - Private
    private func playEffect(effect:Effects, value:Float) {
        
        switch effect {
            case .Reverb:
                audioEngine.playAudioWithReverb(value)
            case .Echo:
                audioEngine.playAudioWithEcho(value)
            case .Chipmonk,.DartVader:
                audioEngine.playAudioWithPitch(value)
            case .Slow,.Quick:
                audioEngine.playWithRate(value)
        }
    
    }
    

}

