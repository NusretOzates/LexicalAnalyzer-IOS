//
//  ViewController.swift
//  LexicalAnalyzer
//
//  Created by Nusret Özateş on 12.05.2018.
//  Copyright © 2018 Nusret Özateş. All rights reserved.
//

import UIKit
import Speech


class ViewController: UIViewController,UITextViewDelegate,SFSpeechRecognizerDelegate {
  
    @IBOutlet weak var textForAnalyze: UITextView!
    @IBOutlet weak var recordVoice: UIButton!
    @IBOutlet weak var analyzeButton: UIButton!
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var listening = false
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
        textForAnalyze.delegate = self
        speechRecognizer?.delegate = self
        textForAnalyze.clipsToBounds = true
        textForAnalyze.layer.cornerRadius = 20
        recordVoice.layer.cornerRadius = 20
        analyzeButton.layer.cornerRadius = 20
        
    }

    @IBAction func refreshButton(_ sender: UIButton) {
        textForAnalyze.text = " "
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textForAnalyze.text = " "
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func startVoiceRecording(_ sender: UIButton) {
        askMicPermission(completion: { (granted, message) in
            DispatchQueue.main.async {
                if self.listening {
                    self.listening = false
                    
                    if granted {
                        self.stopListening()
                    }
                } else {
                    self.listening = true
                    self.recordVoice.setTitle("Recording", for: .normal)
                    if granted {
                        self.startListening()
                    }
                }
            }
        })
    }
        func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
            recordVoice.isEnabled = available
            if available {
                listening = true
                recordVoice.setTitle("Tap to Record", for: .normal)
                startVoiceRecording(recordVoice)
            } else {
                textForAnalyze.text = "Recognition is not available."
            }
        }
    
    private func startListening() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch let error {
            textForAnalyze.text = "An error occurred when starting audio session. \(error.localizedDescription)"
            return
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
         let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.textForAnalyze.text = result?.bestTranscription.formattedString
                isFinal = result!.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.recordVoice.setTitle("Tap to Record", for: .normal)
            }
            
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch let error {
            textForAnalyze.text = "An error occurred starting audio engine. \(error.localizedDescription)"
        }
    }
    private func stopListening() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
    }
    
    private func askMicPermission(completion: @escaping (Bool, String) -> ()) {
        SFSpeechRecognizer.requestAuthorization { status in
            let message: String
            var granted = false
            
            switch status {
            case .authorized:
                message = "Listening..."
                granted = true
                break
            case .denied:
                message = "Access to speech recognition is denied by the user."
                break
            case .restricted:
                message = "Speech recognition is restricted."
                break
            case .notDetermined:
                message = "Speech recognition has not been authorized, yet."
                break
            }
            completion(granted,message)
        }
    }
    
    }
    

