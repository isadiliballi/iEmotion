//
//  ViewController.swift
//  iEmotion
//
//  Created by İsa Diliballı on 15.05.2020.
//  Copyright © 2020 İsa Diliballı. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UIScrollViewDelegate{

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
    var keyboardheight = CGRect()
    
    var emotioncontrol = false
    
    var EmotionsEmoji : [String] = ["smileemoji","happyemoji","normalemoji","angryemoji","sademoji","worriedemoji","loveemoji","excitedemoji"]
    var color = [UIColor.init(displayP3Red: 255/255, green: 220/255, blue: 0, alpha: 1),UIColor.orange,UIColor.green,UIColor.init(displayP3Red: 160/255, green: 0, blue: 0, alpha: 1),UIColor.init(displayP3Red: 61/255, green: 90/255, blue: 254/255, alpha: 1),UIColor.init(displayP3Red: 0, green: 255, blue: 255, alpha: 1),UIColor.red,UIColor.init(displayP3Red: 128, green: 0, blue: 128, alpha: 1)]
    var EmotionControl = 0
    
    var emotiontext = String()
    var emotion = String()
    var emotionnumber = Int()
    let date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = " iEmotion"
        let titleback = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = titleback
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        textboxview.layer.cornerRadius = 20
        textboxview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        textboxtext.delegate = self
        textboxtext.text = "Biraz anlatmak ister misin?"
        textboxtext.textColor = UIColor.lightGray
        textboxtext.selectedTextRange = textboxtext.textRange(from: textboxtext.beginningOfDocument, to: textboxtext.beginningOfDocument)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ScrollTapped(tapGestureRecognizer:)))
            EmotionScroll.isUserInteractionEnabled = true
            EmotionScroll.addGestureRecognizer(tapGestureRecognizer)
        
        var frame = CGRect(x: view.frame.width / 2 - 100, y: 100, width: 200, height: 200)
        EmotionPage.numberOfPages = EmotionsEmoji.count
        for index in 0..<EmotionsEmoji.count {
            frame.origin.x = EmotionScroll.frame.size.width * CGFloat(index) + 87.5
    
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: EmotionsEmoji[index])
            self.EmotionScroll.addSubview(imgView)
        }
        EmotionScroll.contentSize = CGSize(width: (EmotionScroll.frame.size.width * CGFloat(EmotionsEmoji.count)), height: EmotionScroll.frame.size.height)
        EmotionScroll.delegate = self
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
    @IBAction func EmotionAction(_ sender: Any) {
        emotionactive()
        emotion = "MUTLU"
        emotionnumber = 1
        self.title = "Mutlu"
    }
    @objc func ScrollTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        _ = tapGestureRecognizer.view as! UIScrollView
        
        emotionactive()
        
        let width = EmotionScroll.frame.width
        let page = Int(round(EmotionScroll.contentOffset.x/width))
        
        if page == 1 {
            emotion = "HAYAT DOLU"
            emotionnumber = 2
            self.title = "Hayat Dolu"
        }
        if page == 2 {
            emotion = "NORMAL"
            emotionnumber = 3
            self.title = "Normal"
        }
        if page == 3 {
            emotion = "KIZGIN"
            emotionnumber = 4
            self.title = "Kızgın"
        }
        if page == 4 {
            emotion = "ÜZGÜN"
            emotionnumber = 5
            self.title = "Üzgün"
        }
        if page == 5 {
            emotion = "ENDİŞELİ"
            emotionnumber = 6
            self.title = "Endişeli"
        }
        if page == 6 {
            emotion = "AŞIK"
            emotionnumber = 7
            self.title = "Aşk"
        }
        if page == 7 {
            emotion = "HEYECANLI"
            emotionnumber = 8
            self.title = "Heyecanlı"
        }
}
    
    @IBAction func settingsaction(_ sender: Any) {
    }
    @IBAction func statisticsaction(_ sender: Any) {
    }
    
    @IBAction func cancel(_ sender: Any) {
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
        
        textboxokay.frame.origin.y += keyboardheight.height
        textboxcancel.frame.origin.y += keyboardheight.height
        self.title = "iEmotion"
    }
    @IBAction func okay(_ sender: Any) {
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
            
            textboxtext.resignFirstResponder()
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.title = "iEmotion"
                self.darkbackground.isHidden = true
                successful.removeFromSuperview()
            }
        }
        catch {
        }
        textboxokay.frame.origin.y += keyboardheight.height
        textboxcancel.frame.origin.y += keyboardheight.height
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                keyboardheight = keyboardSize
                self.textboxokay.frame.origin.y -= keyboardSize.height
                self.textboxcancel.frame.origin.y -= keyboardSize.height
                textboxtext.frame.size = CGSize(width: textboxtext.frame.width, height: textboxokay.frame.minY - textboxokay.frame.width / 2)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
        self.textboxokay.frame.origin.y = 0
        self.textboxokay.frame.origin.y = 0
    }
    }
}
