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
        recordingLabel.text = "Recording in progress..."
        stopRecordingButton.isEnabled = true
        stopRecordingButton.layer.opacity = 1
        recordButton.isEnabled = false
        recordButton.layer.opacity = 0.5
        
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
    
    @IBAction func stopAudioRecording(_ sender: Any) {
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        recordButton.layer.opacity = 1
        stopRecordingButton.layer.opacity = 0.5
        recordingLabel.text = "Tap to Record"
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
