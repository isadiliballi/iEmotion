//
//  Statistics.swift
//  iEmotion
//
//  Created by İsa Diliballı on 19.05.2020.
//  Copyright © 2020 İsa Diliballı. All rights reserved.
//

import UIKit
import CoreData

class Statistics: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var EmotionList: UITableView!
    
    var dateArray = [String]()
    var dateArray2 = [String]()
    var moontext = String()
    var year = String()
    var idArray = [UUID]()
    var idArray2 = [UUID]()
    var emotionArray = [String]()
    var emotionArray2 = [String]()
    var emotionTextArray = [String]()
    var emotionTextArray2 = [String]()
    
    @IBOutlet weak var emotionview: UIView!
    @IBOutlet weak var emotioncancel: UIButton!
    @IBOutlet weak var emotiontext: UITextView!
    @IBOutlet weak var darkbackground: UIImageView!
    
    var smileColor = UIColor.init(displayP3Red: 255/255, green: 220/255, blue: 0, alpha: 1)
    var happyColor = UIColor.orange
    var normalColor = UIColor.green
    var angryColor = UIColor.init(displayP3Red: 160/255, green: 0, blue: 0, alpha: 1)
    var sadColor = UIColor.init(displayP3Red: 61/255, green: 90/255, blue: 254/255, alpha: 1)
    var worriedColor = UIColor.init(displayP3Red: 0, green: 255, blue: 255, alpha: 1)
    var loveColor = UIColor.red
    var excitedColor = UIColor.init(displayP3Red: 128, green: 0, blue: 128, alpha: 1)
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleback = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = titleback
        
        emotionview.layer.cornerRadius = 20
        emotionview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        EmotionList.delegate = self
        EmotionList.dataSource = self
        
        dataUpdate()
    }
    
    @IBAction func istatistikgo(_ sender: Any) {
        if dateArray.isEmpty == false {
            performSegue(withIdentifier: "istatistik", sender: nil)
        }
        else {
            let alert = UIAlertController(title: "Emo!", message: "Önce günlüğünüze emo eklemeniz gerekiyor. Bir önceki sayfaya gidin.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "TAMAM", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func dataUpdate() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emotion")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let date = result.value(forKey: "date") as? String {
                    self.dateArray2.append(date)
                    dateArray = Array(dateArray2.reversed())
                }
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray2.append(id)
                   idArray = Array(idArray2.reversed())
                }
                if let emotion = result.value(forKey: "emotion") as? String {
                    self.emotionArray2.append(emotion)
                    emotionArray = Array(emotionArray2.reversed())
                }
                if let emotiontext = result.value(forKey: "emotiontext") as? String {
                    self.emotionTextArray2.append(emotiontext)
                    emotionTextArray = Array(emotionTextArray2.reversed())
                }
            }
        }
        catch {
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "emotion") as! TableViewCell
        
        year = String(dateArray[indexPath.row].prefix(4))
        
        let d1 = String.Index(encodedOffset: 8)
        let day1 = String((dateArray[indexPath.row])[d1])
        let d2 = String.Index(encodedOffset: 9)
        let day2 = String((dateArray[indexPath.row])[d2])
        let day3 = String("\(day1)\(day2)")
        
        let m1 = String.Index(encodedOffset: 5)
        let moon1 = String((dateArray[indexPath.row])[m1])
        let m2 = String.Index(encodedOffset: 6)
        let moon2 = String((dateArray[indexPath.row])[m2])
        let moon3 = String("\(moon1)\(moon2)")
        
        if moon3 == "01" {
            moontext = "OCAK"
        }
        else if moon3 == "02" {
            moontext = "ŞUBAT"
        }
        else if moon3 == "03" {
            moontext = "MART"
        }
        else if moon3 == "04" {
            moontext = "NİSAN"
        }
        else if moon3 == "05" {
            moontext = "MAYIS"
        }
        else if moon3 == "06" {
            moontext = "HAZİRAN"
        }
        else if moon3 == "07" {
            moontext = "TEMMUZ"
        }
        else if moon3 == "08" {
            moontext = "AĞUSTOS"
        }
        else if moon3 == "09" {
            moontext = "EYLÜL"
        }
        else if moon3 == "10" {
            moontext = "EKİM"
        }
        else if moon3 == "11" {
            moontext = "KASIM"
        }
        else if moon3 == "12" {
            moontext = "ARALIK"
        }
        
        cell.dateText.text = "\(day3) \(moontext)"
        cell.yeartext.text = "\(year)"
        
        if emotionArray[indexPath.row] == "MUTLU" {
            cell.emotionImage.image = UIImage(named:"smileemoji")
            cell.emotioncolorview.backgroundColor = smileColor
        }
        else if emotionArray[indexPath.row] == "HAYAT DOLU" {
            cell.emotionImage.image = UIImage(named:"happyemoji")
            cell.emotioncolorview.backgroundColor = happyColor
        }
        else if emotionArray[indexPath.row] == "NORMAL" {
            cell.emotionImage.image = UIImage(named:"normalemoji")
            cell.emotioncolorview.backgroundColor = normalColor
        }
        else if emotionArray[indexPath.row] == "KIZGIN" {
            cell.emotionImage.image = UIImage(named:"angryemoji")
            cell.emotioncolorview.backgroundColor = angryColor
        }
        else if emotionArray[indexPath.row] == "ÜZGÜN" {
            cell.emotionImage.image = UIImage(named:"sademoji")
            cell.emotioncolorview.backgroundColor = sadColor
        }
        else if emotionArray[indexPath.row] == "ENDİŞELİ" {
            cell.emotionImage.image = UIImage(named:"worriedemoji")
            cell.emotioncolorview.backgroundColor = worriedColor
        }
        else if emotionArray[indexPath.row] == "AŞIK" {
            cell.emotionImage.image = UIImage(named:"loveemoji")
            cell.emotioncolorview.backgroundColor = loveColor
        }
        else if emotionArray[indexPath.row] == "HEYECANLI" {
            cell.emotionImage.image = UIImage(named:"excitedemoji")
            cell.emotioncolorview.backgroundColor = excitedColor
        }
        
        cell.emotioncolorview.layer.cornerRadius = 20
       
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        emotionview.isHidden = false
        emotioncancel.isHidden = false
        emotiontext.isHidden = false
        darkbackground.isHidden = false
        emotiontext.text = emotionTextArray[indexPath.row]
        emotiontext.isEditable = false
    }
    @IBAction func cancel(_ sender: Any) {
        emotionview.isHidden = true
        emotioncancel.isHidden = true
        emotiontext.isHidden = true
        darkbackground.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emotion")
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            do {
            let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                idArray.remove(at: indexPath.row)
                                emotionTextArray.remove(at: indexPath.row)
                                dateArray.remove(at: indexPath.row)
                                emotionArray.remove(at: indexPath.row)
                                EmotionList.reloadData()
                                do {
                                try context.save()
                                }
                                catch {
                                    
                                }
                            }
                        }
                    }
                }
            }
            catch {
                
            }
            
        }
    }
}
