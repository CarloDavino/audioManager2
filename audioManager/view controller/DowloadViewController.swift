//
//  DowloadViewController.swift
//  audioManager
//
//  Created by Andrea Di Francia on 25/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//

import UIKit
import CloudKit


class DowloadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    
    let database = CKContainer.default().privateCloudDatabase
    var titles = [CKRecord]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        tableview.delegate = self
        tableview.dataSource = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(queryTitle), for: .valueChanged)
        self.tableview.refreshControl = refreshControl
        queryTitle()
       
        // Do any additional setup @objc after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return titles.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            let note = titles[indexPath.row].value(forKey: "Content") as! String
            cell.textLabel?.text = note
            return cell
        }
    
    @objc func queryTitle(){
        let query = CKQuery(recordType: "Title", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            self.titles = records
            DispatchQueue.main.async {
                self.tableview.refreshControl?.endRefreshing()
                self.tableview.reloadData()
            }
        }

}
}
