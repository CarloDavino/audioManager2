//
//  singleton.swift
//  audioManager
//
//  Created by Carlo on 25/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//

import Foundation

public class Singleton{
    
    public static let shared = Singleton()
    var audio = [Audio()]
    var playlist = [Playlist()]
    var choicePlaylist = ""
    
}
