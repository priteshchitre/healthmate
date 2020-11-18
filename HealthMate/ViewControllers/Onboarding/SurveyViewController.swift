//
//  SurveyViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit

class SurveyViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var continueButton: RoundButton!
    
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
    }
    
    func initView() {
        
        self.titleLabel.text = "How_Active_are_you_from_day_to_day".toLocalize()
        self.continueButton.setTitle("Continue".toLocalize(), for: UIControl.State.normal)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.continueButton.backgroundColor = Color.disableGray
    }
    
    @IBAction func onContinueButtonTap(_ sender: Any) {
        
//        let view = self.storyboard?.instantiateViewController(withIdentifier: "SingleInputeViewController") as! SingleInputeViewController
//        view.selectedType = INPUT_TYPE.EXPRECTED_WEIGHT
//        self.navigationController?.pushViewController(view, animated: true)
        if self.selectedIndex == -1 {
            return
        }
        UserClass.setActiveIndex(self.selectedIndex)
        NotificationCenter.default.post(name: NSNotification.Name("MoveView"), object: nil)
    }
}
extension SurveyViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.getActivityArray() .count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let titleLabel = cell.viewWithTag(100) as! UILabel
        let detailsLabel = cell.viewWithTag(101) as! UILabel
        let bgView = cell.viewWithTag(102)!
        titleLabel.text = Global.getActivityArray()[indexPath.row]
        detailsLabel.text = Global.getActivityDescriptionArray()[indexPath.row]
        
        bgView.backgroundColor = UIColor.white
        bgView.layer.cornerRadius = 5
        bgView.layer.borderWidth = 0.25
        bgView.layer.borderColor = UIColor.white.cgColor
        bgView.layer.shadowOpacity = 0.5
        bgView.layer.shadowRadius = 6.0
        bgView.layer.shadowOffset = CGSize.zero // Use any CGSize
        bgView.layer.shadowColor = UIColor(red: 200, green: 200, blue: 200).cgColor
        
        if self.selectedIndex == indexPath.row {
            bgView.backgroundColor = Color.appOrange
        }
        else {
            bgView.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.row
        self.tableView.reloadData()
        self.continueButton.backgroundColor = Color.roundButtonColor
    }
}
