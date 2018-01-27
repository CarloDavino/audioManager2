//
//  Section.swift
//  audioManager
//
//  Created by Andrea Di Francia on 27/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//

import Foundation

struct Section {
    
    var title: String!
    var titleAudio: [String]!
    var expanded: Bool!
    
    init(title: String,titleAudio: [String], expanded: Bool){
         self.title = title
         self.titleAudio = titleAudio
         self.expanded = expanded
    }
}
