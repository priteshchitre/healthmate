//
//  TrackCell.swift
//  HealthMate
//
//  Created by AppDeveloper on 28/10/20.
//

import UIKit

class TrackCell: UITableViewCell {

    //TitleCell
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    //CaloriesCell
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var caloriesLeftLabel: UILabel!
    
    @IBOutlet weak var consumedCountLabel: UILabel!
    @IBOutlet weak var consumedTextLabel: UILabel!
    
    @IBOutlet weak var burnCountLabel: UILabel!
    @IBOutlet weak var burnTextLabel: UILabel!
    @IBOutlet weak var netCountLabel: UILabel!
    @IBOutlet weak var netTextLabel: UILabel!
    
    //WeightCell
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightImageView: UIImageView!
    @IBOutlet weak var weightTextLabel: UILabel!
    @IBOutlet weak var weightCountLabel: UILabel!
    
    //MealCell
    @IBOutlet weak var breackfastImageView: UIImageView!
    @IBOutlet weak var breakfastTextLabel: UILabel!
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var breackfastView: UIView!
    
    @IBOutlet weak var lunchImageView: UIImageView!
    @IBOutlet weak var lunchTextLabel: UILabel!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var lunchView: UIView!
    
    @IBOutlet weak var dinnerView: UIView!
    @IBOutlet weak var dinnerImageView: UIImageView!
    @IBOutlet weak var dinnerTextLabel: UILabel!
    @IBOutlet weak var dinnerButton: UIButton!
    
    @IBOutlet weak var snackView: UIView!
    @IBOutlet weak var snackImageView: UIImageView!
    @IBOutlet weak var snackLabel: UILabel!
    @IBOutlet weak var snakeButton: UIButton!
    
    //BottomCell
    
    @IBOutlet weak var exerciseView: UIView!
    @IBOutlet weak var exerciseImageView: UIImageView!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var exerciseViewWidth: NSLayoutConstraint!
    @IBOutlet weak var exerciseViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var bottomWeightView: UIView!
    @IBOutlet weak var bottomWeightLabel: UILabel!
    @IBOutlet weak var bottomWeightTextLabel: UILabel!
    @IBOutlet weak var bottomWeightViewWidth: NSLayoutConstraint!
    @IBOutlet weak var bottomWeightViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var waterImageView: UIImageView!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var waterViewHeight: NSLayoutConstraint!
    @IBOutlet weak var waterViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var bottomWeightButton: UIButton!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var bottomWeightImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
class ProgressCell: UITableViewCell {
    
    @IBOutlet weak var titleLabl: UILabel!
    
    @IBOutlet weak var labelBottom: NSLayoutConstraint!
    @IBOutlet weak var labelTop: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
