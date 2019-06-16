//
//  tipsTableViewCell.swift
//  fours
//
//  Created by MacBookPro on 11.06.2019.
//  Copyright © 2019 Samet Dogru. All rights reserved.
//

import UIKit

class tipsTableViewCell: UITableViewCell {

   
    @IBOutlet weak var tipsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipsLabel.text = "xxXx"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
