//
//  StatisticsTableViewTableViewCell.swift
//  iEmotion
//
//  Created by İsa Diliballı on 20.05.2020.
//  Copyright © 2020 İsa Diliballı. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    
      @IBOutlet weak var emotionImage: UIImageView!
      @IBOutlet weak var dateText: UILabel!
     @IBOutlet weak var emotioncolorview: UIView!
    @IBOutlet weak var yeartext: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
