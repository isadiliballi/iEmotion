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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
