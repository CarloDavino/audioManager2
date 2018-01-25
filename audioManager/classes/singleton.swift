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
    
    func SaveToCloud(title: String){
        let newTitle = CKRecord(recordType: "Title")
        newTitle.setValue(title, forKey: "Content")
        
        database.save(newTitle) { (record, error) in
            guard record != nil else { return }
            print("save title in database")
        }
    }
    
   
    }
