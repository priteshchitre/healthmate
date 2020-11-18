//
//  ActivitySelectionViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 10/11/20.
//

import UIKit

class ActivitySelectionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedRow : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setGrayBackBarButton()
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Activity".toLocalize())
        self.setDoneBarButton()
        
        self.selectedRow = UserClass.getActiveIndex()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
    }
    
    func setDoneBarButton() {
        
        let backButton : UIButton = UIButton()
        backButton.setTitle("Done".toLocalize(), for: UIControl.State.normal)
        backButton.setTitleColor(Color.appOrange, for: UIControl.State.normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(self.onDoneButtonTapped), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.sizeToFit()
        backButton.titleLabel?.textAlignment = .right
        backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = backBarButton
    }
    
    @objc func onDoneButtonTapped() {
        
        UserClass.setActiveIndex(self.selectedRow)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
extension ActivitySelectionViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.getActivityArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(100) as! UILabel
        let imageView = cell.viewWithTag(101) as! UIImageView
        label.text = Global.getActivityArray()[indexPath.row]
        imageView.image = UIImage(named: "checkmark")?.image(withTintColor: Color.appOrange)
        if self.selectedRow == indexPath.row {
            imageView.isHidden = false
        }
        else {
            imageView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedRow = indexPath.row
        self.tableView.reloadData()
    }
}
