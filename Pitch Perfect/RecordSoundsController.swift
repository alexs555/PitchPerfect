//
//  RecordSoundsController.swift
//  Pitch Perfect
//
//  Created by Алексей Шпирко on 05/06/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLbl: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    
    private var soundsEngine:SoundsEngine!
    private var recordedAudio:RecorderedAudio!
    
    private var inRecordingState: Bool = false {
        didSet {
            self.recordingLbl.text = self.inRecordingState ? "Recording..." : "Tap to record"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Record"
        soundsEngine = SoundsEngine()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.stopButton.hidden = true
        self.pauseResumeButton.hidden = true
        self.recordButton.enabled = true;
        
    }

    @IBAction func recordAudio(sender: UIButton) {
        
        self.inRecordingState = true
        self.stopButton.hidden = false
        self.recordButton.enabled = false;
        self.pauseResumeButton.hidden = false
        
        soundsEngine.startRecordingAudioWithDelegate(self)

    }

    @IBAction func stopRecordingAudio(sender: UIButton) {
        
        self.inRecordingState = false
        self.recordButton.enabled = true
        
        soundsEngine.stopRecordingAudio()
    }
    
    @IBAction func pauseResumeBtnPressed(sender: UIButton) {
        
        if (soundsEngine.audioRecorder.recording) {
            soundsEngine.audioRecorder.pause()
        } else {
            soundsEngine.audioRecorder.record()
        }
        setRecordingButtonState(soundsEngine.audioRecorder.recording)
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecorderedAudio(filePath: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            
            let audio = sender as! RecorderedAudio
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            playSoundsVC.receivedAudio = audio
            
        }
    }
    
    
    private func setRecordingButtonState(recording:Bool) {
        
        pauseResumeButton.setImage( recording ? UIImage(named: "pause") : UIImage(named: "resume") , forState: UIControlState.Normal)
        recordingLbl.text = recording ? "Recording..." : "Paused"
        
    }
    
}

