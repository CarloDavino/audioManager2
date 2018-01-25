//
//  Playlist+CoreDataProperties.swift
//  audioManager
//
//  Created by Carlo on 25/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//
//

import Foundation
import CoreData


extension Playlist {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playlist> {
        return NSFetchRequest<Playlist>(entityName: "Playlist")
    }

    @NSManaged public var name: String?

}
