//
//  FoodListCell.swift
//  HealthMate
//
//  Created by AppDeveloper on 28/10/20.
//

import UIKit

class FoodListCell: UITableViewCell {

    
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var searchView: UIView!
//    @IBOutlet weak var searchImageView: UIImageView!
//    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var eatenTodayButton: UIButton!
    @IBOutlet weak var myFoodButton: UIButton!
    
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
