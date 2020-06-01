//
//  settingsTableViewCell.swift
//  iEmotion
//
//  Created by İsa Diliballı on 31.05.2020.
//  Copyright © 2020 İsa Diliballı. All rights reserved.
//

import UIKit

class settingsTableViewCell: UITableViewCell {

    @IBOutlet weak var back: UIView!
    @IBOutlet weak var backtext: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.animate(withDuration: 0.3,
        animations: {
            self.back.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.back.transform = CGAffineTransform.identity
            }
        })
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        }
    }
    




