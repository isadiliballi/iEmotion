//
//  TableViewCell2.swift
//  iEmotion
//
//  Created by İsa Diliballı on 22.05.2020.
//  Copyright © 2020 İsa Diliballı. All rights reserved.
//

import UIKit

class TableViewCell2: UITableViewCell {

    @IBOutlet weak var emotionimage: UIImageView!
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var percentcolor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        UIView.animate(withDuration: 0.2,
        animations: {
            self.percentcolor.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        },
        completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.percentcolor.transform = CGAffineTransform.identity
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
