//
//  ViewControllerSelectedPlaylist.swift
//  audioManager
//
//  Created by Carlo on 25/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//


import UIKit
import AVFoundation

class ViewControllerSelectedPlaylist: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var singleton = Singleton.shared
    var audio:[Audio]? = nil
    var audioPlayer: AVAudioPlayer!
    var audioInPlaylist = [String()]
    
    
    @IBOutlet weak var titlePlaylist: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func back(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        titlePlaylist.text = singleton.choicePlaylist
        audio = CoreDataManager.fetchObject()
        myTableView.delegate = self
        myTableView.dataSource = self
        print("choice:" + singleton.choicePlaylist)
        for a in audio!
        {
            if a.playlist == singleton.choicePlaylist
            {
                print("a:" + a.playlist! + ",singleton:" + singleton.choicePlaylist + ",a.name:" + a.name!)
                audioInPlaylist.append(a.name!)
            }
        }
        
    }
    
    //Setting Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioInPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = audioInPlaylist[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let path = try getDirectory().appendingPathComponent(audioInPlaylist[indexPath.row] + ".m4a")
        
        
        
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer.volume = 100.0
            audioPlayer.play()
        }
        catch
        {
            displayAlert(title: "Ops", message: "Play audio failed")
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            
            let path = self.getDirectory().appendingPathComponent(self.audioInPlaylist[indexPath.row] + ".m4a")
            print("share button tapped")
            
            
            let activityVC = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
            
        }
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            
            print("delete button tapped")
            
            self.deleteAudio(documentsUrl: self.getDirectory().appendingPathComponent(self.audioInPlaylist[indexPath.row] + ".m4a"))
            CoreDataManager.deleteInCoreData(audio: self.audio!, name: self.audioInPlaylist[indexPath.row])
            self.audioInPlaylist.remove(at: indexPath.row)
            self.audio = CoreDataManager.fetchObject()
            
            self.myTableView.reloadData()
            
            
        }
        delete.backgroundColor = UIColor.red
        share.backgroundColor = UIColor.blue
        
        
        return [share,delete]
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
    
    
    
    
    
    
}

