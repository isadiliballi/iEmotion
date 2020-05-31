//
//  settings.swift
//  iEmotion
//
//  Created by İsa Diliballı on 31.05.2020.
//  Copyright © 2020 İsa Diliballı. All rights reserved.
//

import UIKit

class settings: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTableView: UITableView!
    var text = ["REKLAMLARI KALDIR","SATIN ALINANLARI GERİ YÜKLE","EMOLARI İCLOUD'A YEDEKLE","İCLOUD'DAN EMOLARI ÇEK","HAKKINDA"]
    var backcolor = [UIColor.init(displayP3Red: 40/255, green: 196/255, blue: 1/255, alpha: 1),UIColor.init(displayP3Red: 255/255, green: 139/255, blue: 0/255, alpha: 1),UIColor.init(displayP3Red: 255/255, green: 81/255, blue: 0/255, alpha: 1),UIColor.init(displayP3Red: 255/255, green: 0/255, blue: 135/255, alpha: 1),UIColor.init(displayP3Red: 232/255, green: 0/255, blue: 255/255, alpha: 1)]

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "setting") as! settingsTableViewCell
        cell.backtext.text = text[indexPath.row]
        cell.back.backgroundColor = UIColor.black
        cell.back.layer.cornerRadius = 15
        return cell
    }
}
