//
//  OptionItemsTableViewCell.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 04/09/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit

class OptionItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var ItemImage: UIImageView!
    @IBOutlet weak var ItemTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
