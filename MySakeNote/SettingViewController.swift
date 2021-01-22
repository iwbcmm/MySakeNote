//
//  SettingViewController.swift
//  MySakeNote
//
//  Created by 岩渕真未 on 2020/12/07.
//  Copyright © 2020 岩渕真未. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let latestInformation = ["ブログ", "Twitter", "Facebook"]
    let sectionTitle: NSArray = ["最新情報"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        self.title = "設定"
            
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 255/255)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section] as? String
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return latestInformation.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = String(latestInformation[indexPath.row])
            cell.textLabel?.textColor = .black
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            cell.backgroundColor = .white
            let cellBackgroundView = UIView()
            cellBackgroundView.backgroundColor = UIColor(red: 221/255, green: 238/255, blue: 255/255, alpha: 255/255)
            cell.selectedBackgroundView = cellBackgroundView
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let url = URL(string: "http://blog.sakenote.com/")
            UIApplication.shared.open(url!)
        case 1:
            let url = URL(string: "https://twitter.com/sakenote2012")
            UIApplication.shared.open(url!)
        case 2:
            let url = URL(string: "https://www.facebook.com/sakenote/")
            UIApplication.shared.open(url!)
        default:
            break
        }
    }
    
}
