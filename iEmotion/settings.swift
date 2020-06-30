//
//  settings.swift
//  iEmotion
//
//  Created by İsa Diliballı on 31.05.2020.
//  Copyright © 2020 İsa Diliballı. All rights reserved.
//

import UIKit
import CloudKit
import CoreData
import Network
import StoreKit
import SwiftyStoreKit

class settings: UIViewController, UITableViewDelegate, UITableViewDataSource, SKPaymentTransactionObserver {
    
    let privateDatabase = CKContainer.default().privateCloudDatabase
    var datecloud = [String]()
    var idcloud = [String]()
    var emotioncloud = [String]()
    var emotiontextcloud = [String]()
    
    let monitor = NWPathMonitor()
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var bluractivity: UIActivityIndicatorView!
    @IBOutlet weak var blurtext: UILabel!
    
    let productID = "isadiliballi.iEmotion"
    var restored = [SKPaymentTransaction]()
    
    let sharedSecret = "637119d3a0fc4e3682b3da44cb06ed0f"
    
    var text = ["REKLAMLARI KALDIR","SATIN ALINANLARI GERİ YÜKLE","EMOLARI ICLOUD'A YEDEKLE","ICLOUD'DAN EMOLARI ÇEK","HAKKINDA"]
    var backcolor = [UIColor.init(displayP3Red: 40/255, green: 196/255, blue: 1/255, alpha: 1),UIColor.init(displayP3Red: 255/255, green: 139/255, blue: 0/255, alpha: 1),UIColor.init(displayP3Red: 255/255, green: 81/255, blue: 0/255, alpha: 1),UIColor.init(displayP3Red: 255/255, green: 0/255, blue: 135/255, alpha: 1),UIColor.init(displayP3Red: 232/255, green: 0/255, blue: 255/255, alpha: 1)]
    
    var removead = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleback = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = titleback
        removead = UserDefaults.standard.object(forKey: "removead") as! Bool
        SKPaymentQueue.default().add(self)
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        
        verifypurchase(with: productID, sharedSecret: sharedSecret)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if removead == false {
                    self.bluractivity.startAnimating()
                    self.blur.isHidden = false
                    self.blurtext.text = ""
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.navigationItem.hidesBackButton = true
            
            if SKPaymentQueue.canMakePayments() {
                let paymentRequest = SKMutablePayment()
                paymentRequest.productIdentifier = self.productID
                SKPaymentQueue.default().add(paymentRequest)
            }
            else {
            }
            }
            else {
                blur.isHidden = false
                blurtext.text = "Zaten Satın Alındı!"
                bluractivity.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.bluractivity.isHidden = false
                    self.blur.isHidden = true
                }
            }
        }
        if indexPath.row == 1 {
            self.bluractivity.startAnimating()
                    self.blur.isHidden = false
                    self.blurtext.text = ""
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.navigationItem.hidesBackButton = true
            SKPaymentQueue.default().restoreCompletedTransactions()
        }
        if indexPath.row == 2 {
            cloudkitsave()
            bluractivity.startAnimating()
            blur.isHidden = false
            blurtext.text = "EMOLAR YEDEKLENİYOR"
        }
        if indexPath.row == 3 {
            cloudkitfetch()
            bluractivity.startAnimating()
            blur.isHidden = false
            blurtext.text = "EMOLAR İNDİRİLİYOR"
        }
        if indexPath.row == 4 {
            performSegue(withIdentifier: "info", sender: nil)
        }
    }
    
    func cloudkitsave() {
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.bluractivity.stopAnimating()
                            self.blur.isHidden = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            let successful = UIImageView(image: UIImage(named: "successful")!)
                            successful.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.width / 2)
                            successful.center = self.view.center
                            self.view.addSubview(successful)
                            UIView.animate(withDuration: 0.2,
                                           animations: {
                                            successful.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            },
                                           completion: { _ in
                                            UIView.animate(withDuration: 0.2) {
                                                successful.transform = CGAffineTransform.identity
                                            }
                            })
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                successful.removeFromSuperview()
                            }
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.bluractivity.stopAnimating()
                            self.blur.isHidden = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            let successful = UIImageView(image: UIImage(named: "cancel")!)
                            successful.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.width / 2)
                            successful.center = self.view.center
                            self.view.addSubview(successful)
                            UIView.animate(withDuration: 0.2,
                                           animations: {
                                            successful.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            },
                                           completion: { _ in
                                            UIView.animate(withDuration: 0.2) {
                                                successful.transform = CGAffineTransform.identity
                                            }
                            })
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                successful.removeFromSuperview()
                            }
                        }
                    }
                })
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.bluractivity.stopAnimating()
                    self.blur.isHidden = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    let successful = UIImageView(image: UIImage(named: "cancel")!)
                    successful.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.width / 2)
                    successful.center = self.view.center
                    self.view.addSubview(successful)
                    UIView.animate(withDuration: 0.2,
                                   animations: {
                                    successful.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    },
                                   completion: { _ in
                                    UIView.animate(withDuration: 0.2) {
                                        successful.transform = CGAffineTransform.identity
                                    }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        successful.removeFromSuperview()
                    }
                }
            }
        }
        // </D2>
    }
    
    func cloudkitfetch() {
        let recordID = CKRecord.ID(recordName: "1")
        
        privateDatabase.fetch(withRecordID: recordID) { (updateRecord, error) in
            
            if error == nil {
                self.privateDatabase.save(updateRecord!, completionHandler: { (newRecord, error) in
                    
                    if error == nil {
                        self.datecloud = (updateRecord?["Date"])!
                        
                        self.idcloud = (updateRecord?["Id"])!
                        
                        self.emotioncloud = (updateRecord?["Emotion"])!
                        
                        self.emotiontextcloud = (updateRecord?["EmotionText"])!
                        self.monitor.pathUpdateHandler = { path in
                            if path.status == .satisfied {
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self.bluractivity.stopAnimating()
                                    self.blur.isHidden = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    let successful = UIImageView(image: UIImage(named: "cancel")!)
                                    successful.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.width / 2)
                                    successful.center = self.view.center
                                    self.view.addSubview(successful)
                                    UIView.animate(withDuration: 0.2,
                                                   animations: {
                                                    successful.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    },
                                                   completion: { _ in
                                                    UIView.animate(withDuration: 0.2) {
                                                        successful.transform = CGAffineTransform.identity
                                                    }
                                    })
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        successful.removeFromSuperview()
                                    }
                                }
                            }
                        }
                        let queue = DispatchQueue(label: "Monitor")
                        self.monitor.start(queue: queue)
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.bluractivity.stopAnimating()
                            self.blur.isHidden = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            let successful = UIImageView(image: UIImage(named: "cancel")!)
                            successful.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.width / 2)
                            successful.center = self.view.center
                            self.view.addSubview(successful)
                            UIView.animate(withDuration: 0.2,
                                           animations: {
                                            successful.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                            },
                                           completion: { _ in
                                            UIView.animate(withDuration: 0.2) {
                                                successful.transform = CGAffineTransform.identity
                                            }
                            })
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                successful.removeFromSuperview()
                            }
                        }
                    }
                })
            }
            else {
            }
        }
        // </D1>
    }
    func cloudfetchcoredatesave() {
        if datecloud.isEmpty == false {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Emotion")
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            do {
                let result = try context.execute(request)
            }
            catch {
                
            }
            
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.bluractivity.stopAnimating()
                        self.blur.isHidden = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        let successful = UIImageView(image: UIImage(named: "successful")!)
                        successful.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.width / 2)
                        successful.center = self.view.center
                        self.view.addSubview(successful)
                        UIView.animate(withDuration: 0.2,
                                       animations: {
                                        successful.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        },
                                       completion: { _ in
                                        UIView.animate(withDuration: 0.2) {
                                            successful.transform = CGAffineTransform.identity
                                        }
                        })
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            successful.removeFromSuperview()
                        }
                    }
                }
                catch {
                }
            }
        }
    }
    
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                removead = true
                UserDefaults.standard.set(true, forKey: "removead")
                SKPaymentQueue.default().finishTransaction(transaction)
                self.bluractivity.stopAnimating()
                self.blur.isHidden = true
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.navigationItem.hidesBackButton = false
            }
            else if transaction.transactionState == .restored {
                SKPaymentQueue.default().restoreCompletedTransactions()
                removead = true
                UserDefaults.standard.set(true, forKey: "removead")
                restored.append(transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
                self.bluractivity.stopAnimating()
                self.blur.isHidden = true
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.navigationItem.hidesBackButton = false
                
                    let successful = UIImageView(image: UIImage(named: "successful")!)
                    successful.frame = CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: self.view.frame.width / 2)
                    successful.center = self.view.center
                    self.view.addSubview(successful)
                    UIView.animate(withDuration: 0.2,
                                   animations: {
                                    successful.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    },
                                   completion: { _ in
                                    UIView.animate(withDuration: 0.2) {
                                        successful.transform = CGAffineTransform.identity
                                    }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        successful.removeFromSuperview()
                    }
                
            }
            else if transaction.transactionState == .failed {
                self.bluractivity.stopAnimating()
                self.blur.isHidden = true
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
                self.navigationItem.hidesBackButton = false
            }
            else {
            }
        }
    }

    
    func verifypurchase(with productID: String, sharedSecret: String) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = productID
                
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                    
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("\(productId) is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
}
