//
//  singleton.swift
//  audioManager
//
//  Created by Carlo on 25/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//

import Foundation
import CloudKit

protocol DataManagerDelegate {
    func errorUpdating(error: NSError)
    func modelUpdated()
}

public class Singleton{
    
    public static let shared = Singleton()
    var audio = [Audio()]
    var playlist = [Playlist()]
    var choicePlaylist = ""
    
    var messages : [Message] = []
    var delegate : DataManagerDelegate?
    var arraySections : [Section] = []
    
    //for CLoud
   
    let database = CKContainer.default().privateCloudDatabase
    var sections = Section(title: "", titleAudio: [], expanded: false)
    
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
    
    func queryTitle(){
        let query = CKQuery(recordType: "Messages", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (results, error) -> Void in
            if error != nil {
                print (error ?? "error: nil")
                DispatchQueue.main.async() {
                    self.delegate?.errorUpdating(error: error! as NSError)
                    return
                }
            } else {
                print("Ricevo Dati")
                self.messages.removeAll(keepingCapacity: true)
                
                //caricamento del record in memoria
                for record in results! {
                    print(record)
                    let message = Message(record: record as CKRecord, database: self.database)
                    self.messages.append(message)
                    
                }
               // print("Stampo tutto l array\(self.messages)")
            }
            
            DispatchQueue.main.async() {
                self.delegate?.modelUpdated()
            }
        }
    }
    
   func Ordinamento() -> [Section] {

//Deve farlo prima!!!
        DispatchQueue.main.async() {
            self.queryTitle()
        }
    
        for i in messages {
            
            if i.textTitle == " "{
                
            }
            else{
             sections.title! = i.textTitle
            
             print("RICEVO IL TITOLO: \(sections.title!)")
            //prelevo tutte le tracceAudio in quella lista
             for j in messages {
                if  sections.title! == j.textTitle {
                    if i.textAudio == j.textAudio {
                        print("lo stesso")
                    }
                    else{
                    sections.titleAudio.append(j.textAudio)
                    i.textTitle = " "
                    j.textTitle = " "
                    }
                i.textTitle = " "
                }
                else{
                    
                }
      
            }
                sections.titleAudio.append(i.textAudio)
                print("Ricevo: \(sections)")
                arraySections.append(sections)
                sections.titleAudio = []
        }
        
    }
    print ("Mando: \(arraySections)")
    return arraySections
  }
}
