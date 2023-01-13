//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by TEJAKO3-Old Mac on 07/12/22.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordingButton.isEnabled = false
        stopRecordingButton.layer.opacity = 0.5
    }
    

    @IBAction func recordAudio(_ sender: Any) {
        toggleRecordAndStopButtonSettings(statusLabel: recordingLabel, recordBtn: recordButton, stopBtn: stopRecordingButton, isStopBtnEnabled: true, isRecordBtnEnabled: false, text: "Recording in progress...", stopBtnOpacity: 1, recordBtnOpacity: 0.5)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
           let recordingName = "recordedVoice.wav"
           let pathArray = [dirPath, recordingName]
           let filePath = URL(string: pathArray.joined(separator: "/"))
        
           let session = AVAudioSession.sharedInstance()
           try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

           try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
           audioRecorder.isMeteringEnabled = true
           audioRecorder.prepareToRecord()
           audioRecorder.record()
    }
    
    func toggleRecordAndStopButtonSettings(statusLabel: UILabel, recordBtn: UIButton, stopBtn: UIButton, isStopBtnEnabled: Bool ,isRecordBtnEnabled: Bool, text: String, stopBtnOpacity: Float, recordBtnOpacity: Float){
        statusLabel.text = text
        stopBtn.isEnabled = isStopBtnEnabled
        stopBtn.layer.opacity = stopBtnOpacity
        recordBtn.isEnabled = isRecordBtnEnabled
        recordBtn.layer.opacity = recordBtnOpacity
    }
    
    @IBAction func stopAudioRecording(_ sender: Any) {
        
        toggleRecordAndStopButtonSettings(statusLabel: recordingLabel, recordBtn: recordButton, stopBtn: stopRecordingButton, isStopBtnEnabled: false, isRecordBtnEnabled: true, text: "Tap to Record", stopBtnOpacity: 0.5, recordBtnOpacity: 1)
        
        audioRecorder.stop()
          let audioSession = AVAudioSession.sharedInstance()
          try! audioSession.setActive(false)
    }
    
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            if sender is URL{
                let recordAudioURL = sender as! URL
                playSoundsVC.recordedAudioURL = recordAudioURL
            }
        }
    }
}
