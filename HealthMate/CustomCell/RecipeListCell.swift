//
//  RecipeListCell.swift
//  HealthMate
//
//  Created by AppDeveloper on 29/10/20.
//

import UIKit
import Charts
class RecipeListCell: UITableViewCell {

    //TitleCell
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    //MealCell
    
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var snackButton: UIButton!
    
    //PreferencesCell
    @IBOutlet weak var preferencesLabel: UILabel!
    
    //RecipeCell
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var seringLabel: UILabel!
    
    //RecipeDetailsCell
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dot1View: UIView!
    @IBOutlet weak var dot2View: UIView!
    @IBOutlet weak var dot3View: UIView!
    
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var proteinLabel: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!
    
    
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var timeImageView: UIImageView!
    
    @IBOutlet weak var preperationLabel: UILabel!
    @IBOutlet weak var cookLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var recipeDetailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
