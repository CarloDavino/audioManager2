//
//  Messager.swift
//  audioManager
//
//  Created by Andrea Di Francia on 29/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//


import UIKit
import  CloudKit

// Costrutto message, ovvero un'intera tupla del database, da notare il CKAssert, tipo dati che ci permewtte di ottenere l'URL della canzone caricata precedentwemente sul database

class Message: NSObject {
    var record : CKRecord!
    var database : CKDatabase!
    
    var textTitle : String
    var textAudio: String
    //var song : CKAsset?
    var expanded = false
    
    init(record : CKRecord, database: CKDatabase) {
        self.record = record
        self.database = database
        
        self.textTitle = record.object(forKey: "TitoloLista") as! String
        self.textAudio = record.object(forKey: "TitoloAudio") as! String
        
       // self.song = record.object(forKey: "song") as? CKAsset
    }
}

