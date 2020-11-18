//
//  WorkoutCell.swift
//  HealthMate
//
//  Created by AppDeveloper on 29/10/20.
//

import UIKit

class WorkoutCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    //ExerciseCell
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
