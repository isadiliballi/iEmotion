//
//  istatistik.swift
//  iEmotion
//
//  Created by İsa Diliballı on 22.05.2020.
//  Copyright © 2020 İsa Diliballı. All rights reserved.
//

import UIKit
import CoreData

class istatistik: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var emotionsTableView: UITableView!
    @IBOutlet weak var back: UIButton!
    var emotionArray = [String]()
    var emotionPercent = [String]()
    
    var emotions = ["MUTLU","HAYAT DOLU","NORMAL","KIZGIN","ÜZGÜN","ENDİŞELİ","AŞIK","HEYECANLI"]
    var emotionsImage = ["smileemoji","happyemoji","normalemoji","angryemoji","sademoji","worriedemoji","loveemoji","excitedemoji"]
    var emotionsColor = [UIColor.init(displayP3Red: 255/255, green: 220/255, blue: 0, alpha: 1),UIColor.orange,UIColor.green,UIColor.init(displayP3Red: 160/255, green: 0, blue: 0, alpha: 1),UIColor.init(displayP3Red: 61/255, green: 90/255, blue: 254/255, alpha: 1),UIColor.init(displayP3Red: 0, green: 255, blue: 255, alpha: 1),UIColor.red,UIColor.init(displayP3Red: 128, green: 0, blue: 128, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emotionsTableView.delegate = self
        emotionsTableView.dataSource = self
        
        pullData()
        
        var counts: [String: Int] = [:]
        emotionArray.forEach { counts[$0, default: 0] += 1 }
        
        var smilecount = counts["MUTLU"]
        var happycount = counts["HAYAT DOLU"]
        var normalcount = counts["NORMAL"]
        var angrycount = counts["KIZGIN"]
        var sadcount = counts["ÜZGÜN"]
        var worriedcount = counts["ENDİŞELİ"]
        var lovecount = counts["AŞIK"]
        var excitedcount = counts["HEYECANLI"]
        
        if smilecount == nil {
            smilecount = 0
        }
        else {
            smilecount = Int(counts["MUTLU"]!)
        }
        if happycount == nil {
            happycount = 0
        }
        else {
            happycount = Int(counts["HAYAT DOLU"]!)
        }
        if normalcount == nil {
            normalcount = 0
        }
        else {
            normalcount = Int(counts["NORMAL"]!)
        }
        if angrycount == nil {
            angrycount = 0
        }
        else {
            angrycount = Int(counts["KIZGIN"]!)
        }
        if sadcount == nil {
            sadcount = 0
        }
        else {
            sadcount = Int(counts["ÜZGÜN"]!)
        }
        if worriedcount == nil {
            worriedcount = 0
        }
        else {
            worriedcount = Int(counts["ENDİŞELİ"]!)
        }
        if lovecount == nil {
            lovecount = 0
        }
        else {
            lovecount = Int(counts["AŞIK"]!)
        }
        if excitedcount == nil {
            excitedcount = 0
        }
        else {
            excitedcount = Int(counts["HEYECANLI"]!)
        }
        
        let total = Int(smilecount!) + Int(happycount!) + Int(normalcount!) + Int(angrycount!) + Int(sadcount!) + Int(worriedcount!) + Int(lovecount!) + Int(excitedcount!)
        
        let smile = Int((Float(smilecount!) / Float(total)) * 100)
        let happy = Int((Float(happycount!) / Float(total)) * 100)
        let normal = Int((Float(normalcount!) / Float(total)) * 100)
        let angry = Int((Float(angrycount!) / Float(total)) * 100)
        let sad = Int((Float(sadcount!) / Float(total)) * 100)
        let worried = Int((Float(worriedcount!) / Float(total)) * 100)
        let love = Int((Float(lovecount!) / Float(total)) * 100)
        let excited = Int((Float(excitedcount!) / Float(total)) * 100)
        
        emotionPercent.append(String(smile))
        emotionPercent.append(String(happy))
        emotionPercent.append(String(normal))
        emotionPercent.append(String(angry))
        emotionPercent.append(String(sad))
        emotionPercent.append(String(worried))
        emotionPercent.append(String(love))
        emotionPercent.append(String(excited))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emotion2") as! TableViewCell2
        cell.emotionimage.image = UIImage(named: emotionsImage[indexPath.row])
        cell.backgroundColor = emotionsColor[indexPath.row]
        cell.percent.text = "%\(emotionPercent[indexPath.row])"
        return cell
    }
    
    
    
    @IBAction func backaction(_ sender: Any) {
    }
    
    func pullData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emotion")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let emotion = result.value(forKey: "emotion") as? String {
                    self.emotionArray.append(emotion)
                }
            }
        }
        catch {
        }
    }
    
}
