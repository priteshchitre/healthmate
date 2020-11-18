//
//  UserProfileCell.swift
//  HealthMate
//
//  Created by AppDeveloper on 30/10/20.
//

import UIKit

class UserProfileCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentDetailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
