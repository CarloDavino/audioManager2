//
//  ViewController.swift
//  audioManager
//
//  Created by Carlo on 25/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioRecorderDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var numberOfRecords: Int = 0
    var textField = ""
    var textPlaylist = ""
    
    let pickerView = UIPickerView(frame:
        CGRect(x: 0, y: 50, width: 270, height: 100))
    
    var audio = [Audio()]
    var playlist:[Playlist]? = nil
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var circle: UIImageView!
    @IBOutlet weak var audioSavedLabel: UILabel!
    
    
    
    @IBAction func record(_ sender: Any) {
        
        //check if we have an  active recorder
        if audioRecorder == nil
        {
            
            audioCreationAlert()
            
        }
        else
        {
            //Stopping audio recording
            self.circle?.layer.removeAnimation(forKey: "rotationAnimation")
            circle.isHidden = true
            audioSavedLabel.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.audioSavedLabel.isHidden = true
            }
            audioRecorder.stop()
            audioRecorder = nil
            defaults.set(numberOfRecords, forKey: "myNumber")
            buttonLabel.setTitle("Start Recording", for: .normal)
            audio = CoreDataManager.fetchObject()!
            
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playlist = CoreDataManager.fetchObject()
        pickerView.reloadAllComponents()
        audio = CoreDataManager.fetchObject()!
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recordingSession = AVAudioSession.sharedInstance()
        audioSavedLabel.alpha = 0.7
        
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() {  allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print ("Accepted")
                    } else {
                        print ("Filed")
                    }
                }
            }
        } catch {
            print ("Filed")
        }
        
        
        if let number: Int = defaults.integer(forKey: "myNumber") as? Int
        {
            numberOfRecords = number
        }
        print(numberOfRecords)
    }
    
    // other function
    
    func deleteAudio(documentsUrl: URL){
        
        // Create a FileManager instance
        
        let fileManager = FileManager.default
        
        // Delete 'hello.swift' file
        
        do {
            try fileManager.removeItem(atPath: documentsUrl.path)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
        
    }
    
    
    
    //Function that gets path to directory
    
    func getDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    //Function that display an alert
    func displayAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default
            , handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func audioCreationAlert()
    {
        let alert = UIAlertController(title: "Create new Audio",
                                      message: "\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        
        let labelError = UILabel(frame:
            CGRect(x: 84, y: 145, width: 270, height: 20))
        
        // Submit button
        let submitAction = UIAlertAction(title: "Create", style: .default, handler: { (action) -> Void in
            self.textField = alert.textFields![0].text!
            print(self.textField)
            
            if self.textField != ""
            {
                
                if !(self.alreadyExist(audio: self.audio, name: self.textField))
                {
                    // start circle animation
                    self.circle.isHidden = false
                    let rotationAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                    rotationAnimation.toValue = NSNumber(value: .pi * 2.0)
                    rotationAnimation.duration = 2;
                    rotationAnimation.isCumulative = true;
                    rotationAnimation.repeatCount = .infinity;
                    self.circle?.layer.add(rotationAnimation, forKey: "rotationAnimation")
                    
                    
                    //Save in CLoudKit
                    Singleton.shared.SaveToCloud(title: self.textPlaylist)
                    //start recording
                    self.numberOfRecords += 1
                    CoreDataManager.saveObject(name: self.textField, playlist: self.textPlaylist)
                    let fileName = self.getDirectory().appendingPathComponent(self.textField + ".m4a")
                    let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
                    //Starting audio recording
                    do
                    {
                        self.audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                        self.self.audioRecorder.delegate = self
                        self.audioRecorder.record()
                        self.buttonLabel.setTitle("Stop Recording", for: .normal)
                    }
                    catch
                    {
                        self.displayAlert(title: "Ops", message: "Recording failed")
                        
                    }
                }
                else
                {
                    labelError.isHidden = false
                    labelError.text = "*Already existing title"
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else
            {
                labelError.isHidden = false
                self.present(alert, animated: true, completion: nil)
            }
            
            
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Title"
            textField.clearButtonMode = .whileEditing
        }
        
        //pickerView
        
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.clear
        
        let label = UILabel(frame:
            CGRect(x: 113, y: 50, width: 270, height: 20))
        label.text = "Playlist"
        
        
        labelError.text = "*Required field"
        labelError.textColor = UIColor.red
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        alert.view.addSubview(label)
        alert.view.addSubview(pickerView)
        alert.view.addSubview(labelError)
        labelError.isHidden = true
        
        
        present(alert, animated: true, completion: nil)
    }
    
    //setting picker view
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return playlist!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return playlist?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textPlaylist = playlist![row].name!
    }
    
    
    // other
    
    func alreadyExist(audio: [Audio], name: String) -> Bool {
        for a in audio
        {
            
            if a.name == name
            {
                return true
            }
        }
        return false
    }
}



