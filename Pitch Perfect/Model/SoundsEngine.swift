//
//  SoundsEngine.swift
//  Pitch Perfect
//
//  Created by Алексей Шпирко on 13/06/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import Foundation
import AVFoundation

class SoundsEngine {
    
    private var audioEngine = AVAudioEngine()
    private var audioFile:AVAudioFile!
    private var audioPlayer:AVAudioPlayer!
    private var filePathUrl:NSURL?
    
    var audioRecorder:AVAudioRecorder!
    
    //initializer tunes engine for playing audio
    init(filePathUrl:NSURL) {
        
        self.audioFile = AVAudioFile(forReading:filePathUrl, error: nil)
        self.filePathUrl = filePathUrl
        createPlayer()
    }
    
    //initializer by default tunes engine for recording audio
    init() {
        
        createRecorder()
    }
    
    //MARK:  - Playing audio
    
    func playAudioWithReverb(wetDryMix: Float) {
        playAudioWithEffect(AVAudioUnitReverb(), value: wetDryMix)
    }
    
    func playAudioWithEcho(feedback: Float) {
        playAudioWithEffect(AVAudioUnitDelay(), value: feedback)
    }
    
    func playAudioWithPitch(pitch: Float) {
        playAudioWithEffect(AVAudioUnitTimePitch(), value: pitch)
    }
    
    func resetAudioEngine() {
        
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func stopPlaying () {
        
        audioPlayer.stop()
        audioEngine.stop()
    }
    
    func playWithRate(rate:Float) {
        
        resetAudioEngine()
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioPlayer.rate = rate
        audioPlayer.play()
        
    }
     //MARK:  - Recording audio
    func startRecordingAudioWithDelegate(delegate:AVAudioRecorderDelegate) {
        
        audioRecorder.stop()
        audioRecorder.prepareToRecord()
        audioRecorder.delegate = delegate
        audioRecorder.record()
    }
    
    func stopRecordingAudio() {
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
     //MARK:  - Private methods
    
    private func playAudioWithEffect(effect: AVAudioUnit, value:Float) {
        
        audioPlayer.stop()
        
        resetAudioEngine()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        if let reverb = effect as? AVAudioUnitReverb {
            reverb.wetDryMix = value
        } else if let pitch = effect as? AVAudioUnitTimePitch {
            pitch.pitch = value
        } else if let speed = effect as? AVAudioUnitVarispeed {
            speed.rate = value
        } else if let delay = effect as? AVAudioUnitDelay {
            delay.feedback = value
        }
        
        audioEngine.attachNode(effect)
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    private func createPlayer() {
        
        if let fileURL = filePathUrl {
            audioPlayer = AVAudioPlayer(contentsOfURL: fileURL, error:nil)
            audioPlayer.enableRate = true
        } else {
            println("no file at path provided")
        }
        
    }
    
    private func createRecorder() {
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "myAudio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
    }

}