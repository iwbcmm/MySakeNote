//
//  SakeViewController.swift
//  MySakeNote
//
//  Created by 岩渕真未 on 2020/12/07.
//  Copyright © 2020 岩渕真未. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import SafariServices

struct Sakes: Codable {
    var sakes: [SakeModel]
}

struct SakeModel: Codable, Equatable {
    let sakeIdentifyCode: String
    let sakeName: String
    let sakeFurigana: String
    let sakeAlphabet: String
    let makerName: String
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case sakeIdentifyCode = "sake_identify_code"
        case sakeName = "sake_name"
        case sakeFurigana = "sake_furigana"
        case sakeAlphabet = "sake_alphabet"
        case makerName = "maker_name"
        case url
    }
    
}

class SakeViewController: UIViewController, UISearchBarDelegate,  UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate, UINavigationControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.delegate = self
        self.tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        
        self.title = "お酒検索"
        
        backBtn = UIBarButtonItem(title:"＜マイ酒", style: .done, target: self, action: #selector(self.onClick))
        self.navigationItem.leftBarButtonItem = backBtn
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 255/255)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 228/255, blue: 225/255, alpha: 255/255)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var backBtn: UIBarButtonItem!
    var sakes: [SakeModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var currentPage0: Int = 1
    var currentPage: Int = 1
    var searchWord: String = ""
    var loadStatus: String = "initial"
    var isLoading: Bool = false
    
    private var firstAppear: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            allSake()
            firstAppear = true
    }
    
    @objc func onClick() {
        let sakeVC = storyboard?.instantiateViewController(withIdentifier: "toMysake")
        let navigationController = UINavigationController(rootViewController: sakeVC!)
        navigationController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.15
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController(sakeVC!, animated: false)
    }
    
    func allSake() {

        guard loadStatus != "fetching" && loadStatus != "full" else {
               return
           }
        loadStatus = "fetching"
        guard let req_url = URL(string: "https://www.sakenote.com/api/v1/sakes?token=614dec4fa2aa98801c2d9f79fb214beb5dd3c4d9") else {
            return
            }
        print(req_url)

        var params: [String:Any] = [:]
        params["page"] = currentPage0
          
        let request = AF.request(req_url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response { response in
                guard let data = response.data else { return }
                do {
                    let decoder: JSONDecoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let sakej : Sakes = try JSONDecoder().decode(Sakes.self, from: data)
                    if sakej.sakes.count == 0 {
                       self.loadStatus = "full"
                       return
                       }
                    self.sakes = self.sakes + sakej.sakes
                    self.loadStatus = "loadmore"
                    self.isLoading = false
                    self.currentPage0 += 1
                    print(self.currentPage0)
                    print("-----------------------")
                    } catch let error { print(error) }
            }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        sakes = []
        currentPage = 1
        guard let word = searchBar.text else {
            return
        }
        self.searchWord = word
        print(searchWord)
        searchSake(keyword: searchWord)
    }
    
    func searchSake(keyword: String) {
        guard loadStatus != "fetching" && loadStatus != "full" else { return }
        loadStatus = "fetching"
        guard let req_url = URL(string: "https://www.sakenote.com/api/v1/sakes?token=614dec4fa2aa98801c2d9f79fb214beb5dd3c4d9") else { return }
        print(req_url)

        var params: [String:Any] = [:]
        if keyword.count > 0 {
            params["sake_name"] = keyword
            params["page"] = currentPage
        }
        
        let request = AF.request(req_url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response { response in
                guard let data = response.data else { return }
                do {
                    let decoder: JSONDecoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    print("-----------------------")
                    print(response)
                    let sakejson : Sakes = try JSONDecoder().decode(Sakes.self, from: data)
                    if sakejson.sakes.count == 0 {
                        self.loadStatus = "full"
                        return
                    }
                    self.sakes = self.sakes + sakejson.sakes
                    self.loadStatus = "loadmore"
                    self.isLoading = false
                    self.currentPage += 1
                    print("-----------------------")
                } catch let error{ print(error) }
            }
        request.cURLDescription { v in
            print(v)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sakes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.sakeName.text = sakes[indexPath.row].sakeName
        cell.sakeFurigana.text = sakes[indexPath.row].sakeAlphabet
        cell.sakeID = sakes[indexPath.row].sakeIdentifyCode
        cell.name = sakes[indexPath.row].sakeName
        
        if UserDefaults.standard.string(forKey: cell.sakeID) == sakes[indexPath.row].sakeIdentifyCode {
            cell.favoriteButton.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0, alpha: 1.0)
        } else {
            cell.favoriteButton.tintColor = .lightGray
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(sakes[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        let safariViewController = SFSafariViewController(url: sakes[indexPath.row].url)
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = tableView.contentOffset.y
        let maximamuOffset = tableView.contentSize.height - tableView.frame.height
        let distanceToBottom = maximamuOffset - currentOffsetY
        if distanceToBottom < 500 {
            if searchWord.count > 0 {
                self.isLoading = true
                searchSake(keyword: searchWord)
            } else {
                self.isLoading = true
                allSake()
            }
        }
    }
    
}
