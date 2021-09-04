//
//  OptionMenuHeaderTableViewCell.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 04/09/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit

class OptionMenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
