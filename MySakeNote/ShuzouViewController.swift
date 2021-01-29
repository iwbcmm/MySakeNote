//
//  ShuzouViewController.swift
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

struct Makers : Codable {
    var makers : [MakersModel]
}

struct MakersModel : Codable{
    let makerID : Int
    let makerName : String
    let makerAddress : String
    let makerURL : String?
    let url : URL
    
    enum CodingKeys: String, CodingKey {
        case makerID = "maker_id"
        case makerName = "maker_name"
        case makerAddress = "maker_address"
        case makerURL = "maker_url"
        case url
    }
    
}

enum Status {
    case empty
    case isLoading
    case full
    case loadmore
}

var loadStatus: Status = .empty


class ShuzouViewController: UIViewController, UISearchBarDelegate,  UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate, UIScrollViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
        self.title = "酒造検索"
        
         self.navigationController?.navigationBar.barTintColor = UIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 255/255)
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    override func viewDidLayoutSubviews() {

      scrollView.contentSize = tableView.frame.size
      scrollView.flashScrollIndicators()

    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
    }

    var makers : [MakersModel] = [] {
           didSet {
               tableView.reloadData()
           }
    }
    var currentPage0: Int = 1
    var currentPage: Int = 1
    var searchWord: String = ""
    var loading: Bool = false
    
    private var firstAppear: Bool = false
       
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStatus = .empty
        allShuzou()
    }
    
    func allShuzou() {
        if loadStatus == .isLoading || loadStatus == .full {
            return
        }
        loadStatus = .isLoading
        guard let req_url = URL(string: "https://www.sakenote.com/api/v1/makers?token=614dec4fa2aa98801c2d9f79fb214beb5dd3c4d9") else {
            return
            }
        print(req_url)

        var params: [String:Any] = [:]
        params["page"] = currentPage0
          
        let request = AF.request(req_url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
            .response { response in
                guard let data = response.data else {return}
                do {
                    let makerj : Makers = try JSONDecoder().decode(Makers.self, from: data)
                    if makerj.makers.count == 0 {
                        loadStatus = .full
                        return
                    }
                    self.makers = self.makers + makerj.makers
                    loadStatus = .loadmore
                    self.currentPage0 += 1
                    print("-----------------------")
                } catch let error {
                    print(error)
                    
                }
            }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        makers = []
        
        searchWord = ""
        
        var word: String = ""
        word = searchBar.text!
        
        if  word != "" {
            currentPage = 1
            loadStatus = .empty
            self.searchWord = word
            searchShuzou(keyword: searchWord)
        } else if word == "" {
            currentPage0 = 1
            loadStatus = .empty
            allShuzou()
        }
    }
       
    func searchShuzou(keyword: String) {
        if loadStatus == .isLoading || loadStatus == .full {
            return
        }
        
        loadStatus = .isLoading
        guard let req_url = URL(string: "https://www.sakenote.com/api/v1/makers?token=614dec4fa2aa98801c2d9f79fb214beb5dd3c4d9") else {
            return
        }
        print(req_url)

        var params: [String:Any] = [:]
        if keyword.count > 0 {
            params["maker_name"] = keyword
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
                    let makerjson : Makers = try JSONDecoder().decode(Makers.self, from: data)
                    if makerjson.makers.count == 0 {
                        loadStatus = .full
                        return
                    }
                    DispatchQueue.main.async() { () -> Void in
                        self.makers = self.makers + makerjson.makers
                        loadStatus = .loadmore
                    }
                    
                    self.currentPage += 1
                    print(self.currentPage)
                    print("-----------------------")
                } catch let error{
                    print(error)
                }
            }
        request.cURLDescription { v in
            print(v)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return makers.count
    }
              

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shuzouCell", for: indexPath)
        cell.textLabel!.text = makers[indexPath.row].makerName
        cell.detailTextLabel?.text = makers[indexPath.row].makerAddress
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(makers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        let safariViewController = SFSafariViewController(url: makers[indexPath.row].url)
        safariViewController.delegate = self
        present(safariViewController, animated: true, completion: nil)
    }
     
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = tableView.contentOffset.y
        let maximamuOffset = tableView.contentSize.height - tableView.frame.height
        let distanceToBottom = maximamuOffset - currentOffsetY
        if distanceToBottom < 500 {
            if searchWord != "" {
                self.loading = true
                searchShuzou(keyword: searchWord)
            } else {
                self.loading = true
                allShuzou()
            }
        }
    }
}
