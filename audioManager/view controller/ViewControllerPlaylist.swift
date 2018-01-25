//
//  ViewControllerPlaylist.swift
//  audioManager
//
//  Created by Carlo on 25/01/18.
//  Copyright © 2018 Carlo. All rights reserved.
//


import UIKit

class ViewControllerPlaylist: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var playlist:[Playlist]? = nil
    var textField = ""
    var singleton = Singleton.shared
    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBAction func addPlaylist(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Create new Playlist",
                                      message: "\n\n\n\n\n\n\n",
                                      preferredStyle: .alert)
        
        let labelError = UILabel(frame:
            CGRect(x: 84, y: 145, width: 270, height: 20))
        
        
        // Submit button
        let submitAction = UIAlertAction(title: "Create", style: .default, handler: { (action) -> Void in
            self.textField = alert.textFields![0].text!
            print(self.textField)
            
            if self.textField != ""
            {
            CoreDataManager.savePlaylist(name: self.textField)
            self.playlist = CoreDataManager.fetchObject()
            self.myTableView.reloadData()
            
            }
            else
            {
                labelError.text = "*Required field"
                labelError.isHidden = false
                self.present(alert, animated: true, completion: nil)
            }
        })
        
        // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        // Add 1 textField and customize it
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "Title"
            textField.clearButtonMode = .whileEditing
        }
        
        
        // Add action buttons and present the Alert
        alert.addAction(submitAction)
        alert.addAction(cancel)
        labelError.isHidden = true
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //prelevo i dati dal CoreData
        playlist = CoreDataManager.fetchObject()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        
        
    }
    
    
    
    
    //setting table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        playlist = CoreDataManager.fetchObject()
        cell.textLabel?.text = playlist![indexPath.row].name
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        singleton.choicePlaylist = playlist![indexPath.row].name!
        showPlaylist()
    }
    
    func showPlaylist() {
        let pop = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "selectedPlaylist") as! ViewControllerSelectedPlaylist
        
        self.addChildViewController(pop)
        pop.view.frame = self.view.frame
        self.view.addSubview(pop.view)
        pop.didMove(toParentViewController: self)
    }
    
    
    
    
    
    
    
}

