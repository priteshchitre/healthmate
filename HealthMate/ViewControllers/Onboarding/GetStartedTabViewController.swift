//
//  GetStartedTabViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 27/10/20.
//

import UIKit

class GetStartedTabViewController: XLTwitterPagerTabStripViewController {

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveView), name: NSNotification.Name("MoveView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openCreatingProfileView), name: NSNotification.Name("OpenCreatingProfileView"), object: nil)
    }
    
    func initView() {
        
        self.setNavigationBar()
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Get_Started".toLocalize())
        self.navigationController?.isNavigationBarHidden = false
        self.setBackButton()
        self.containerView.isScrollEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
        
        self.shadowView.backgroundColor = UIColor.white
        self.shadowView.layer.cornerRadius = 0
        self.shadowView.layer.borderWidth = 0.25
        self.shadowView.layer.borderColor = UIColor.white.cgColor
        self.shadowView.layer.shadowOpacity = 0.5
        self.shadowView.layer.shadowRadius = 4.0
        self.shadowView.layer.shadowOffset = CGSize.zero // Use any CGSize
        self.shadowView.layer.shadowColor = UIColor(red: 200, green: 200, blue: 200).cgColor
    }
    
    func setBackButton(_ isHidden : Bool = false) {
        
        let backButton : UIButton = UIButton()
        backButton.setImage(UIImage(named: "Status-Bar-back Arrow-2"), for: UIControl.State())
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backButton.addTarget(self, action: #selector(self.onBackTap), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.imageWith(color: UIColor.black, for: UIControl.State.normal)
        backButton.isHidden = isHidden
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func onBackTap() {
        
        self.selectedIndex -= 1
        if self.selectedIndex < 0 {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            self.moveToViewController(at: UInt(self.selectedIndex))
            self.collectionView.reloadData()
        }
    }
    
    @objc func moveView() {
        
        self.selectedIndex += 1
        if self.selectedIndex == 6 {
            self.getCalorieCalculator()
        }
        else {
            self.moveToViewController(at: UInt(self.selectedIndex))
            self.collectionView.reloadData()
        }
    }
    
    @objc func openCreatingProfileView() {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "CreateProfileViewController") as! CreateProfileViewController
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func getCalorieCalculator() {
        
        if !Global.checkNetworkConnectivity() {
            Global.showNoNetworkAlert()
            return
        }
        
        var currentWeight = UserClass.getWeight()
        var goalWeight = UserClass.getExptectedWeight()
        var currentHeight = UserClass.getHeight()
        
        if UserClass.getWeightMeasurement().lowercased() != "kg" {
            currentWeight = currentWeight / 2.205
        }
        if UserClass.getExptectedWeightMeasurement().lowercased() != "kg" {
            goalWeight = goalWeight / 2.205
        }
        if UserClass.getHeightMeasurement().lowercased() != "cm" {
            currentHeight = currentHeight * 2.54
        }
        
        let param : NSMutableDictionary = [
            "currentWeightKg": currentWeight,
            "heightCm": currentHeight,
            "desiredWeightKg": goalWeight,
            "activityLevel": Global.getActivityLevel(),
            "sex": Global.getGender(),
            "age": Global.getAge()
        ]
        
        Global.showProgressHud()
        
        APIHelperClass.sharedInstance.postRequest("\(APIHelperClass.calorieCalculator)", parameters: param) { (result, error, statusCode) in
            
            DispatchQueue.main.async {
                Global.hideProgressHud()
            }
            
            if statusCode == 200 {
                if let dataDic = result {
                    Global.createJSONDetails("calorieCalculator", jsonData: dataDic)
                    if let dataArray = dataDic.value(forKey: "data") as? NSArray {
                        Global.sharedInstance.calorieCalculatorArray = CalorieCalculatorClass.initWithArray(dataArray)
                        self.moveToViewController(at: UInt(self.selectedIndex))
                        self.collectionView.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    override func childViewControllers(for pagerTabStripViewController: XLPagerTabStripViewController!) -> [Any]! {
        
        let viewControllerArray : NSMutableArray = NSMutableArray()
        
        let view1 = self.storyboard?.instantiateViewController(withIdentifier: "BirthDateSelectionViewController") as! BirthDateSelectionViewController
        viewControllerArray.add(view1)

        let view2 = self.storyboard?.instantiateViewController(withIdentifier: "GenderSelectionViewController") as! GenderSelectionViewController
        viewControllerArray.add(view2)

        let view3 = self.storyboard?.instantiateViewController(withIdentifier: "SingleInputeViewController") as! SingleInputeViewController
        view3.selectedType = INPUT_TYPE.WEIGHT
        viewControllerArray.add(view3)

        let view4 = self.storyboard?.instantiateViewController(withIdentifier: "SingleInputeViewController") as! SingleInputeViewController
        view4.selectedType = INPUT_TYPE.HEIGHT
        viewControllerArray.add(view4)
        
        let view5 = self.storyboard?.instantiateViewController(withIdentifier: "SurveyViewController") as! SurveyViewController
        viewControllerArray.add(view5)

        let view6 = self.storyboard?.instantiateViewController(withIdentifier: "SingleInputeViewController") as! SingleInputeViewController
        view6.selectedType = INPUT_TYPE.EXPRECTED_WEIGHT
        viewControllerArray.add(view6)

        let view7 = self.storyboard?.instantiateViewController(withIdentifier: "GoalViewController") as! GoalViewController
        viewControllerArray.add(view7)

        let view8 = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        viewControllerArray.add(view8)

        let view9 = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        viewControllerArray.add(view9)

        let view10 = self.storyboard?.instantiateViewController(withIdentifier: "NameViewController") as! NameViewController
        viewControllerArray.add(view10)
        
        return viewControllerArray as [AnyObject]
    }
}
extension GetStartedTabViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        let bgView = cell.viewWithTag(101)!
        
        if self.selectedIndex >= indexPath.row {
            bgView.backgroundColor = Color.appOrange
        }
        else {
            bgView.backgroundColor = UIColor.clear

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 10) / 9, height: 5)
    }
}
