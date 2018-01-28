//
//  singleton.swift
//  audioManager
//
//  Created by Carlo on 25/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//

import Foundation
import CloudKit

public class Singleton{
    
    public static let shared = Singleton()
    var audio = [Audio()]
    var playlist = [Playlist()]
    var choicePlaylist = ""
    
    //for CLoud
   
    let database = CKContainer.default().privateCloudDatabase
    
    func SaveToCloud(title: String, titleAudio: String){
        
        let record = CKRecord(recordType: "Messages")
        record.setValue(title, forKey: "TitoloLista")
        record.setValue(titleAudio, forKey: "TitoloAudio")
       // record.setValue(url, forKey: "song")
        
        database.save(record) { (record, error) in
            guard record != nil else { return }
            print("save title in database")
        }
    }
    
   
    }
