//
//  TableViewController.swift
//  audioManager
//
//  Created by Andrea Di Francia on 27/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//

import UIKit
import CloudKit

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandbleHeaderViewDelegate {

     let database = CKContainer.default().privateCloudDatabase
     var titles = [CKRecord]()
    
    @IBOutlet weak var tableView: UITableView!
    
//    var sections = [Section(title: "Fantacalcio",titleAudio: ["GOALLL", "Quagliarella"], expanded: false), Section(title: "Film",titleAudio: ["LOTR", "ToyStory"], expanded: false), Section(title: "Uni",titleAudio: ["Fai Cagare", "VAAAAAAA"], expanded: false), Section(title: "Fantacalcio",titleAudio: ["GOALLL", "Quagliarella"], expanded: false), Section(title: "Film",titleAudio: ["LOTR", "ToyStory"], expanded: false), Section(title: "Uni",titleAudio: ["Fai Cagare", "VAAAAAAA"], expanded: false)]
//
    var sections:[Section]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl

    }

    @objc func refresh() {
        sections = Singleton.shared.Ordinamento()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        sections = Singleton.shared.Ordinamento()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections!.count

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections![section].titleAudio.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections![indexPath.section].expanded!) {
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
        header.customInit(title: sections![section].title!, section: section, delegate: self)
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = sections![indexPath.section].titleAudio![indexPath.row]
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell", for: indexPath)
//        let title = titles[indexPath.row].value(forKey: "TitoloLista") as! String
//        let titleaudio = titles[indexPath.row].value(forKey: "TitoloAudio") as! String
//        cell.textLabel?.text = title
//        cell.detailTextLabel?.text = titleaudio
//        return cell
        
    }

    func toggleSection(header: ExpandbleHeaderView, section: Int) {
        sections![section].expanded = !sections![section].expanded
        
        tableView.beginUpdates()
        for i in 0 ..< sections![section].titleAudio!.count {
            tableView.reloadRows(at: [IndexPath(row: i,section: section)], with: .automatic)
            
        }
        tableView.endUpdates()
    }
    
//    @objc func queryTitle(){
//        let query = CKQuery(recordType: "Messages", predicate: NSPredicate(value: true))
//        database.perform(query, inZoneWith: nil) { (records, _) in
//            guard let records = records else { return }
//            self.titles = records
//            DispatchQueue.main.async {
//                self.tableView.refreshControl?.endRefreshing()
//                self.tableView.reloadData()
//            }
//        }
//    }
}
