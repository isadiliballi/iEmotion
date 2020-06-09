//
//  ViewController.swift
//  iEmotion
//
//  Created by İsa Diliballı on 15.05.2020.
//  Copyright © 2020 İsa Diliballı. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import Network
import Firebase
import GoogleMobileAds

class ViewController: UIViewController, UIScrollViewDelegate, GADInterstitialDelegate{
    
    @IBOutlet weak var EmotionScroll: UIScrollView!
    @IBOutlet weak var Emotions: UIImageView!
    @IBOutlet weak var EmotionsClick: UIButton!
    @IBOutlet weak var EmotionPage: UIPageControl!
    @IBOutlet weak var darkbackground: UIImageView!
    @IBOutlet weak var textboxtext: UITextView!
    @IBOutlet weak var textboxcancel: UIButton!
    @IBOutlet weak var textboxokay: UIButton!
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var statistics: UIButton!
    @IBOutlet weak var textboxview: UIView!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningText1: UILabel!
    @IBOutlet weak var warningText2: UILabel!
    @IBOutlet weak var warningText3: UILabel!
    @IBOutlet weak var warningClose: UIButton!
    var touch = UIImageView()
    var touchtext = UILabel()
    var touchclose = UIButton()
    
    var emotioncontrol = false
    
    var EmotionsEmoji : [String] = ["smileemoji","happyemoji","normalemoji","angryemoji","sademoji","worriedemoji","loveemoji","excitedemoji"]
    var color = [UIColor.init(displayP3Red: 255/255, green: 220/255, blue: 0, alpha: 1),UIColor.orange,UIColor.green,UIColor.init(displayP3Red: 160/255, green: 0, blue: 0, alpha: 1),UIColor.init(displayP3Red: 61/255, green: 90/255, blue: 254/255, alpha: 1),UIColor.init(displayP3Red: 0, green: 255, blue: 255, alpha: 1),UIColor.red,UIColor.init(displayP3Red: 128, green: 0, blue: 128, alpha: 1)]
    var EmotionControl = 0
    
    var emotiontext = String()
    var emotion = String()
    var emotionnumber = Int()
    let date = Date()
    var dateArray = [String]()
    var anddate = Int()
    var today = Int()
    var firstopentouchcontrol = false
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    var datecloud = [String]()
    var idcloud = [String]()
    var emotioncloud = [String]()
    var emotiontextcloud = [String]()
    
    let monitor = NWPathMonitor()
    var interstitial: GADInterstitial!
    var removead = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if removead == false {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        }
        
        let back = NotificationCenter.default
        back.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willEnterForegroundNotification, object: nil)
        self.title = " iEmotion"
        let titleback = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = titleback
        
        UINavigationBar.appearance().tintColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        textboxview.layer.cornerRadius = 20
        textboxview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        textboxtext.delegate = self
        textboxtext.text = "Biraz anlatmak ister misin?"
        textboxtext.textColor = UIColor.lightGray
        textboxtext.selectedTextRange = textboxtext.textRange(from: textboxtext.beginningOfDocument, to: textboxtext.beginningOfDocument)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ScrollTapped(tapGestureRecognizer:)))
        EmotionScroll.isUserInteractionEnabled = true
        EmotionScroll.addGestureRecognizer(tapGestureRecognizer)
        
        var frame = CGRect(x: view.frame.width / 2 - Emotions.frame.width / 2, y: Emotions.frame.origin.y, width: Emotions.frame.width, height: Emotions.frame.width)
        EmotionPage.numberOfPages = EmotionsEmoji.count
        for index in 0..<EmotionsEmoji.count {
            frame.origin.x = (EmotionScroll.frame.size.width * CGFloat(index)) + view.frame.width / 2 - Emotions.frame.width / 2
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: EmotionsEmoji[index])
            self.EmotionScroll.addSubview(imgView)
        }
        EmotionScroll.contentSize = CGSize(width: (EmotionScroll.frame.size.width * CGFloat(EmotionsEmoji.count)), height: EmotionScroll.frame.size.height)
        EmotionScroll.delegate = self
        
        datecontrol()
        warning()
        
        
        let firstopentouch = UserDefaults.standard.bool(forKey: "firstopentouch")
        if firstopentouch  {
            firstopentouchcontrol = UserDefaults.standard.object(forKey: "firstopentouchcontrol") as! Bool
            removead = UserDefaults.standard.object(forKey: "removead") as! Bool
        }
        else {
            UserDefaults.standard.set(true, forKey: "firstopentouch")
            UserDefaults.standard.set(firstopentouchcontrol, forKey: "firstopentouchcontrol")
            UserDefaults.standard.set(removead, forKey: "removead")
        }
        
        if firstopentouchcontrol == false {
            firstopen()
        }
        else {
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / EmotionScroll.frame.size.width
        EmotionPage.currentPage = Int(pageNumber)
        
        for index in 0..<EmotionsEmoji.count {
            if Int(pageNumber) == index {
                EmotionScroll.backgroundColor = color[index]
            }
        }
    }
    
    func datevsdate() {
        if anddate == today {
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.warningView.transform = CGAffineTransform(scaleX: 0, y: 0)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.2) {
                                self.warningView.transform = CGAffineTransform.identity
                            }
            })
            warningView.isHidden = false
            darkbackground.isHidden = false
        }
        else if anddate < today {
            emotionactive()
        }
        else {}
        
    }
    
    
    @IBAction func EmotionAction(_ sender: Any) {
        datevsdate()
        if anddate < today {
            emotion = "MUTLU"
            emotionnumber = 1
            self.title = "mutlu"
        }
    }
    @objc func ScrollTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        _ = tapGestureRecognizer.view as! UIScrollView
        
        let width = EmotionScroll.frame.width
        let page = Int(round(EmotionScroll.contentOffset.x/width))
        
        datevsdate()
        
        if anddate < today {
            if page == 1 {
                emotion = "HAYAT DOLU"
                emotionnumber = 2
                self.title = "hayat dolu"
            }
            if page == 2 {
                emotion = "NORMAL"
                emotionnumber = 3
                self.title = "normal"
            }
            if page == 3 {
                emotion = "KIZGIN"
                emotionnumber = 4
                self.title = "kızgın"
            }
            if page == 4 {
                emotion = "ÜZGÜN"
                emotionnumber = 5
                self.title = "üzgün"
            }
            if page == 5 {
                emotion = "ENDİŞELİ"
                emotionnumber = 6
                self.title = "endişeli"
            }
            if page == 6 {
                emotion = "AŞIK"
                emotionnumber = 7
                self.title = "aşk dolu"
            }
            if page == 7 {
                emotion = "HEYECANLI"
                emotionnumber = 8
                self.title = "heyecanlı"
            }
        }
    }
    func datecontrol() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emotion")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let dates = result.value(forKey: "date") as? String {
                    var dateArray2 = [String]()
                    dateArray2.append(dates)
                    dateArray = Array(dateArray2.reversed())
                }
            }
        }
        catch {
        }
        
        // CoreData'ya kaydedilen son tarih...
        if dateArray.isEmpty == false {
            
        }
        else {
            dateArray.append("2020-01-01 01:01:01")
        }
        let year = String(dateArray[0].prefix(4))
        
        let d1 = String.Index(encodedOffset: 8)
        let day1 = String((dateArray[0])[d1])
        let d2 = String.Index(encodedOffset: 9)
        let day2 = String((dateArray[0])[d2])
        let day3 = String("\(day1)\(day2)")
        
        let m1 = String.Index(encodedOffset: 5)
        let moon1 = String((dateArray[0])[m1])
        let m2 = String.Index(encodedOffset: 6)
        let moon2 = String((dateArray[0])[m2])
        let moon3 = String("\(moon1)\(moon2)")
        let yearmoonday = ("\(year)\(moon3)\(day3)")
        
        anddate = Int(yearmoonday)!
        //
        // Bugünün tarihi 20200524 şeklinde...
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let datetime = dateFormatter.string(from: date as Date)
        today = Int(datetime)!
        //
    }
    @IBAction func settingsaction(_ sender: Any) {
    }
    @IBAction func statisticsaction(_ sender: Any) {
    }
    
    @IBAction func cancel(_ sender: Any) {
        //ADS
        if removead == false {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
         }
        }
        emotioncontrol = false
        if emotioncontrol == false {
            darkbackground.isHidden = true
            textboxview.isHidden = true
            textboxtext.isHidden = true
            textboxokay.isHidden = true
            textboxcancel.isHidden = true
            
            EmotionScroll.isUserInteractionEnabled = true
            EmotionsClick.isUserInteractionEnabled = true
            settings.isUserInteractionEnabled = true
            statistics.isUserInteractionEnabled = true
        }
        textboxtext.resignFirstResponder()
        textboxtext.delegate = self
        textboxtext.text = "Biraz anlatmak ister misin?"
        textboxtext.textColor = UIColor.lightGray
        textboxtext.selectedTextRange = textboxtext.textRange(from: textboxtext.beginningOfDocument, to: textboxtext.beginningOfDocument)
        
        self.title = "iEmotion"
        datecontrol()
    }
    @IBAction func okay(_ sender: Any) {
       //ADS
        if removead == false {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
         }
        }
        
        var emotiontxt = String(textboxtext.text)
        if emotiontxt == "Biraz anlatmak ister misin?" {
            emotiontxt = "Bir şey anlatmadın! :("
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh-mm-ss"
        let datetime = dateFormatter.string(from: date as Date)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newEmotion = NSEntityDescription.insertNewObject(forEntityName: "Emotion", into: context)
        
        newEmotion.setValue(emotion, forKey: "emotion")
        newEmotion.setValue(emotiontxt, forKey: "emotiontext")
        newEmotion.setValue(datetime, forKey: "date")
        newEmotion.setValue(UUID(), forKey:"id")
        
        do {
            try context.save()
            darkbackground.alpha = 0.93
            textboxview.isHidden = true
            textboxtext.isHidden = true
            textboxokay.isHidden = true
            textboxcancel.isHidden = true
            EmotionScroll.isUserInteractionEnabled = true
            EmotionsClick.isUserInteractionEnabled = true
            settings.isUserInteractionEnabled = true
            statistics.isUserInteractionEnabled = true
            self.title = ""
            
            let successful = UIImageView(image: UIImage(named: "successful")!)
            successful.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.width / 2)
            successful.center = view.center
            view.addSubview(successful)
            
            UIView.animate(withDuration: 0.5,
                           animations: {
                            successful.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            },
                           completion: { _ in
                            UIView.animate(withDuration: 0.5) {
                                successful.transform = CGAffineTransform.identity
                            }
            })
            
            textboxtext.resignFirstResponder()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.title = "iEmotion"
                self.darkbackground.isHidden = true
                successful.removeFromSuperview()
            }
        }
        catch {
        }
        
        datecontrol()
        cloudkit()
    }
    
    
    func emotionactive() {
        emotioncontrol = true
        if emotioncontrol == true {
            darkbackground.isHidden = false
            textboxview.isHidden = false
            textboxtext.isHidden = false
            textboxokay.isHidden = false
            textboxcancel.isHidden = false
            
            EmotionScroll.isUserInteractionEnabled = false
            EmotionsClick.isUserInteractionEnabled = false
            settings.isUserInteractionEnabled = false
            statistics.isUserInteractionEnabled = false
        }
        textboxtext.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datecontrol()
    }
    
    func warning() {
        warningView.layer.cornerRadius = 30
        warningView.layer.borderColor = UIColor.red.cgColor
        warningView.layer.borderWidth = 3
    }
    @IBAction func warningCloseAction(_ sender: Any) {
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.warningView.transform = CGAffineTransform(scaleX: 0, y: 0)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.2) {
                            self.warningView.transform = CGAffineTransform.identity
                        }
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.warningView.isHidden = true
            self.darkbackground.isHidden = true
        }
    }
    
    
    
    func firstopen() {
        EmotionsClick.isUserInteractionEnabled = false
        EmotionScroll.isUserInteractionEnabled = false
        statistics.isUserInteractionEnabled = false
        settings.isUserInteractionEnabled = false
        darkbackground.isHidden = false
        darkbackground.alpha = 0.8
        
        let touchimage = UIImage(named: "firstopentouch")
        touch = UIImageView(image: touchimage)
        
        let weight = touch.frame.width / 2
        let height = touch.frame.height / 2
        
        touch.frame = CGRect(x: view.frame.width / 2 - weight / 2, y: view.frame.height / 2.5, width: weight, height: height)
        self.view.addSubview(touch)
        
        touchtext = UILabel(frame: CGRect(x: 0, y: touch.frame.maxY, width: view.frame.width, height: 50))
        touchtext.textAlignment = .center
        touchtext.textColor = UIColor.white
        touchtext.font = UIFont(name: "DIN Condensed", size: 30)
        touchtext.text = "Sürükle ve Dokun"
        self.view.addSubview(touchtext)
        
        touchclose = UIButton(frame: CGRect(x: 0, y: touchtext.frame.maxY, width: view.frame.width, height: 50))
        touchclose.setTitleColor(.green, for: .normal)
        touchclose.setTitle("TAMAM", for: .normal)
        touchclose.titleLabel?.font = UIFont(name: "DIN Condensed", size: 50)
        touchclose.addTarget(self, action: #selector(self.touchcloseaction), for: .touchUpInside)
        self.view.addSubview(touchclose)
        
        // GET DATA <D1>
        let recordID = CKRecord.ID(recordName: "1")
        
        privateDatabase.fetch(withRecordID: recordID) { (updateRecord, error) in
            
            if error == nil {
                self.privateDatabase.save(updateRecord!, completionHandler: { (newRecord, error) in
                    
                    if error == nil {
                        self.datecloud = (updateRecord?["Date"])!
                        
                        self.idcloud = (updateRecord?["Id"])!
                        
                        self.emotioncloud = (updateRecord?["Emotion"])!
                        
                        self.emotiontextcloud = (updateRecord?["EmotionText"])!
                        print("VERİLER ÇEKİLDİ")
                        
                        self.monitor.pathUpdateHandler = { path in
                            if path.status == .satisfied {
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    print("İNTERNET VAR")
                                    var counter = 0
                                    while true {
                                        counter += 1
                                        if self.datecloud.isEmpty == false {
                                            return self.cloudfetchcoredatesave()
                                            break
                                        }
                                    }
                                }
                                
                            }
                            else {
                                print("İNTERNET YOK")
                                
                            }
                        }
                        let queue = DispatchQueue(label: "Monitor")
                        self.monitor.start(queue: queue)
                    } else {
                        print("HATA")
                    }
                    
                })
                
            }
                
            else {
                // CLOUDKIT SAVE <D3>
                let recordName = CKRecord.ID(recordName: "1")
                let cloudsave = CKRecord(recordType: "iEmotion", recordID: recordName)
                self.privateDatabase.save(cloudsave) { (savedRecord, error) in
                    if error == nil {
                        print("SUCCESSFUL")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.savecloud()
                        }
                    }
                    else {
                        print("ERROR")
                    }
                }
                // </D3>
            }
        }
        // </D1>
        
        
    }
    func cloudfetchcoredatesave() {
        if datecloud.isEmpty == false {
            print(datecloud)
            print(idcloud)
            print(emotioncloud)
            print(emotiontextcloud)
            
            for i in 0...datecloud.count - 1 {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let newEmotion = NSEntityDescription.insertNewObject(forEntityName: "Emotion", into: context)
                
                
                newEmotion.setValue(emotioncloud[i], forKey: "emotion")
                newEmotion.setValue(emotiontextcloud[i], forKey: "emotiontext")
                newEmotion.setValue(datecloud[i], forKey: "date")
                newEmotion.setValue(UUID(), forKey:"id")
                
                do {
                    try context.save()
                    print("COREDATA SAVE \(i)")
                }
                catch {
                }
            }
        }
    }
    
    
    @objc func touchcloseaction(sender: UIButton!) {
        EmotionsClick.isUserInteractionEnabled = true
        EmotionScroll.isUserInteractionEnabled = true
        statistics.isUserInteractionEnabled = true
        settings.isUserInteractionEnabled = true
        darkbackground.isHidden = true
        touch.removeFromSuperview()
        touchtext.removeFromSuperview()
        touchclose.removeFromSuperview()
        firstopentouchcontrol = true
        UserDefaults.standard.set(firstopentouchcontrol, forKey: "firstopentouchcontrol")
    }
    
    func savecloud() {
        let recordID = CKRecord.ID(recordName: "1")
        self.privateDatabase.fetch(withRecordID: recordID) { (updateRecord, error) in
            
            if error == nil {
                let dateA = ["2020-01-01 01-01-01"]
                let emotionA = ["MUTLU"]
                let emotiontextA = ["Gösterim amaçlı bir emo, silebilirsiniz!"]
                let idA = [UUID().uuidString]
                
                updateRecord?.setValue(dateA, forKey: "Date")
                updateRecord?.setValue(emotionA, forKey: "Emotion")
                updateRecord?.setValue(idA, forKey: "Id")
                updateRecord?.setValue(emotiontextA, forKey: "EmotionText")
                
                self.privateDatabase.save(updateRecord!, completionHandler: { (newRecord, error) in
                    if error == nil {
                        print("KAYDEDİLDİ")
                    } else {
                        print("HATA")
                    }
                })
            } else {
                print("KAYIT GETİRİLEMEDİ")
            }
        }
    }
    
    func cloudkit() {
        var cloudDate = [String]()
        var cloudId = [String]()
        var cloudEmotion = [String]()
        var cloudEmotionText = [String]()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Emotion")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let date = result.value(forKey: "date") as? String {
                    cloudDate.append(date)
                }
                if let id = result.value(forKey: "id") as? UUID {
                    cloudId.append(id.uuidString)
                }
                if let emotion = result.value(forKey: "emotion") as? String {
                    cloudEmotion.append(emotion)
                }
                if let emotiontext = result.value(forKey: "emotiontext") as? String {
                    cloudEmotionText.append(emotiontext)
                }
            }
        }
        catch {
        }
        if cloudDate.isEmpty == false {
            
        }
        
        // DATE UPDATE <D2>
        let recordID = CKRecord.ID(recordName: "1")
        
        privateDatabase.fetch(withRecordID: recordID) { (updateRecord, error) in
            
            if error == nil {
                
                updateRecord?.setValue(cloudDate, forKey: "Date")
                updateRecord?.setValue(cloudEmotion, forKey: "Emotion")
                updateRecord?.setValue(cloudId, forKey: "Id")
                updateRecord?.setValue(cloudEmotionText, forKey: "EmotionText")
                
                self.privateDatabase.save(updateRecord!, completionHandler: { (newRecord, error) in
                    if error == nil {
                        print("KAYDEDİLDİ")
                    } else {
                        print("HATA")
                    }
                })
            } else {
                print("KAYIT GETİRİLEMEDİ")
            }
        }
        // </D2>
    }
    @objc func appMovedToBackground() {
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            self.textboxokay.frame.origin.y = textboxview.frame.size.height - keyboardSize.height - textboxokay.frame.width * 1.5
                self.textboxcancel.frame.origin.y = textboxview.frame.size.height - keyboardSize.height - textboxcancel.frame.width * 1.5
                textboxtext.frame.size = CGSize(width: textboxtext.frame.width, height: textboxokay.frame.minY - textboxokay.frame.width / 2)
            
        }
    }
}


extension ViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText: NSString = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        if updatedText.isEmpty {
            textboxtext.text = "Biraz anlatmak ister misin?"
            textboxtext.textColor = UIColor.lightGray
            textboxtext.selectedTextRange = textboxtext.textRange(from: textboxtext.beginningOfDocument, to: textboxtext.beginningOfDocument)
            return false
        }
        else if textboxtext.textColor == UIColor.lightGray && !text.isEmpty {
            textboxtext.text = nil
            textboxtext.textColor = UIColor.black
        }
        
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textboxtext.textColor == UIColor.lightGray {
                textboxtext.selectedTextRange = textboxtext.textRange(from: textboxtext.beginningOfDocument, to: textboxtext.beginningOfDocument)
            }
        }
    }
}
