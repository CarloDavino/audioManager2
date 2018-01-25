//
//  CoreDataManager.swift
//  audioManager
//
//  Created by Carlo on 25/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
    }
    
    
    //audio
    class func saveObject(name: String, playlist: String) -> Bool
    {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Audio", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(name, forKey: "name")
        manageObject.setValue(playlist, forKey: "playlist")
        
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    class func fetchObject() -> [Audio]?{
        let context = getContext()
        var audio:[Audio]? = nil
        
        do{
            audio = try context.fetch(Audio.fetchRequest())
            return audio
        }
        catch{
            return audio
        }
    }
    
    class func updateName(audio: Audio, name: String) -> Bool {
        let context = getContext()
        
        audio.setValue(name, forKey: "name")
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    class func updatePlaylist(audio: Audio, playlist: String) -> Bool {
        let context = getContext()
        
        audio.setValue(playlist, forKey: "playlist")
        
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    class func deleteInCoreData(audio: [Audio], name: String) -> Bool {
        let context = getContext()
        
        for a in audio {
            if a.name == name
            {
                context.delete(a)
            }
        }
        
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    //playlist
    
    class func savePlaylist(name: String) -> Bool
    {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Playlist", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        
        manageObject.setValue(name, forKey: "name")
        
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    class func fetchObject() -> [Playlist]?{
        let context = getContext()
        var playlist:[Playlist]? = nil
        
        do{
            playlist = try context.fetch(Playlist.fetchRequest())
            return playlist
        }
        catch{
            return playlist
        }
    }
    
    class func deletePlaylist(playlist: [Playlist], name: String) -> Bool {
        let context = getContext()
        
        for a in playlist {
            if a.name == name
            {
                context.delete(a)
            }
        }
        
        do{
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
}




