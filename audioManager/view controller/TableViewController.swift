//
//  TableViewController.swift
//  audioManager
//
//  Created by Andrea Di Francia on 27/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandbleHeaderViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sections = [Section(title: "Fantacalcio",titleAudio: ["GOALLL", "Quagliarella"], expanded: false),Section(title: "Film",titleAudio: ["LOTR", "ToyStory"], expanded: false),Section(title: "Uni",titleAudio: ["Fai Cagare", "VAAAAAAA"], expanded: false)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].titleAudio.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return 80
        }
        else {
             return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandbleHeaderView()
        header.customInit(title: sections[section].title, section: section, delegate: self)
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = sections[indexPath.section].titleAudio[indexPath.row]
        return cell
    }

    func toggleSection(header: ExpandbleHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        tableView.beginUpdates()
        for i in 0 ..< sections[section].titleAudio.count {
            tableView.reloadRows(at: [IndexPath(row: i,section: section)], with: .automatic)
            
        }
        tableView.endUpdates()
    }
}
