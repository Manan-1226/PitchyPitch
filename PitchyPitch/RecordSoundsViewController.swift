//
//  ViewController.swift
//  PitchyPitch
//
//  Created by Daffolapmac-155 on 25/05/22.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordButton.isEnabled = false

    }
    // for playing the recording
    @IBAction func recordAudio(_ sender: Any) {
        recordLabel.text = "Recording is in process"
        recordButton.isEnabled = false
        stopRecordButton.isEnabled = true
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
    //for stopping the recording
    @IBAction func stopRecording(_ sender: Any) {
        print("Stop recording button was pressed")
        recordButton.isEnabled = true
        stopRecordButton.isEnabled = false
        recordLabel.text = "Tap to record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else{
            print("Error saving file.")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

