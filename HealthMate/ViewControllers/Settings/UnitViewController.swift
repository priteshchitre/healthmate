//
//  UnitViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 9/11/20.
//

import UIKit

class UnitViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initElements()
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setGrayBackBarButton()
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Units_of_Measurement".toLocalize())
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
    }
    
    @objc func onSegmentTap(_ segment : UISegmentedControl) {
        
        if segment.tag == 201 {
            
            if segment.selectedSegmentIndex == 0 {
                UserClass.setSettingWeight("lb")
            }
            else {
                UserClass.setSettingWeight("kg")
            }
        }
        else if segment.tag == 202 {
            
            if segment.selectedSegmentIndex == 0 {
                UserClass.setSettingHeight("inch")
            }
            else {
                UserClass.setSettingHeight("cm")
            }
        }
        else if segment.tag == 203 {
            
            if segment.selectedSegmentIndex == 0 {
                UserClass.setSettingWater("oz")
            }
            else {
                UserClass.setSettingWater("ml")
            }
        }
    }
}
extension UnitViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let imageView = cell.viewWithTag(100) as! UIImageView
        let label = cell.viewWithTag(101) as! UILabel
        let segment = cell.viewWithTag(102) as! UISegmentedControl
        
        if indexPath.row == 0 {

            imageView.image = UIImage(named: "Weight")?.image(withTintColor: UIColor.black)
            label.text = "Weight".toLocalize()
            segment.tag = 201
            segment.setTitle("lb", forSegmentAt: 0)
            segment.setTitle("kg", forSegmentAt: 1)
            segment.addTarget(self, action: #selector(self.onSegmentTap(_:)), for: UIControl.Event.valueChanged)
            if UserClass.getSettingWeight().lowercased() == "kg" {
                segment.selectedSegmentIndex = 1
            }
            else {
                segment.selectedSegmentIndex = 0
            }
        }
        else if indexPath.row == 1 {
            imageView.image = UIImage(named: "Weight")?.image(withTintColor: UIColor.black)
            label.text = "Height".toLocalize()
            segment.tag = 202
            segment.setTitle("inch", forSegmentAt: 0)
            segment.setTitle("cm", forSegmentAt: 1)
            segment.addTarget(self, action: #selector(self.onSegmentTap(_:)), for: UIControl.Event.valueChanged)
            if UserClass.getSettingHeight().lowercased() == "cm" {
                segment.selectedSegmentIndex = 1
            }
            else {
                segment.selectedSegmentIndex = 0
            }
        }
        else {
            imageView.image = UIImage(named: "Water_inactive")?.image(withTintColor: UIColor.black)
            label.text = "Water".toLocalize()
            segment.tag = 203
            segment.setTitle("oz", forSegmentAt: 0)
            segment.setTitle("ml", forSegmentAt: 1)
            segment.addTarget(self, action: #selector(self.onSegmentTap(_:)), for: UIControl.Event.valueChanged)
            if UserClass.getSettingWater().lowercased() == "oz" {
                segment.selectedSegmentIndex = 0
            }
            else {
                segment.selectedSegmentIndex = 1
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
