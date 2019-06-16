//
//  placesTableViewCell.swift
//  fours
//
//  Created by MacBookPro on 11.06.2019.
//  Copyright © 2019 Samet Dogru. All rights reserved.
//

import UIKit

class venuesTableViewCell: UITableViewCell {

    @IBOutlet weak var venuesName: UILabel!
    @IBOutlet weak var venuesAdress: UILabel!
    @IBOutlet weak var venuesCity: UILabel!
    @IBOutlet weak var venuesCountry: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
