//
//  TableViewCell.swift
//  MySakeNote
//
//  Created by 岩渕真未 on 2020/12/25.
//  Copyright © 2020 岩渕真未. All rights reserved.
//

import UIKit
import Foundation

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var sakeName: UILabel!
    @IBOutlet weak var sakeFurigana: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var sakeID: String = ""
    let userDefaults = UserDefaults.standard
    var name: String = ""
    var sakeNameArray: [String] = []
    
    @IBAction func tappedFavoriteButton(_ sender: Any) {
        
        if self.favoriteButton.tintColor == .lightGray {
            // ボタンの色をゴールドに変える
            self.favoriteButton.tintColor = UIColor(red: 1.0, green: 0.8, blue: 0, alpha: 1.0)
            
            //ユーザーデフォルトからお気に入りのidの配列を取得する
            sakeNameArray = self.userDefaults.array(forKey: "sakeNameArray") as? [String] ?? []
            
            // idの配列にタップされた酒のidを追加する
            sakeNameArray.append(name)
            
            print(sakeID)
            print(name)
            print(sakeNameArray)

            //タップされた酒のidが追加された配列をユーザーデフォルトに保存する
            self.userDefaults.set(sakeID, forKey: sakeID)
            self.userDefaults.set(sakeNameArray, forKey: "sakeNameArray")
            print("お気に入り登録をしました")
            
        } else {
            self.favoriteButton.tintColor = .lightGray
            self.userDefaults.removeObject(forKey: sakeID)
            
            sakeNameArray = self.userDefaults.array(forKey: "sakeNameArray") as? [String] ?? []
            let fileteredSakeArray = sakeNameArray.filter { $0 != name }
            self.userDefaults.set(fileteredSakeArray, forKey: "sakeNameArray")
            
            print(fileteredSakeArray)
            print("お気に入り登録を解除しました")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
