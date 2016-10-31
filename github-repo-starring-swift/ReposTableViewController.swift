//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositoriesWithCompletion {
            
            OperationQueue.main.addOperation({
                self.tableView.reloadData()
            })
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        
        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        store.toggleStarStatus(for: repository) { (success) in
            self.showAlertView(success: success, repoName: repository.fullName)
        }
        
    }
    
    func showAlertView(success: Bool, repoName: String) {
        var response = ""
        if success {
            response = "starred"
            
        }else{
            response = "unstarred"
        }
        let sheet = UIAlertController(title: "Alert Message", message: "You just \(response) \(repoName)", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (alert: UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        });
        sheet.addAction(OKAction)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
}
