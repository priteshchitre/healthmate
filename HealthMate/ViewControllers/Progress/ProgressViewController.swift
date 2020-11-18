//
//  ProgressViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 28/10/20.
//

import UIKit
import JBChartView

class ProgressViewController: UIViewController {

    @IBOutlet weak var todayTextLabel: UILabel!
    @IBOutlet weak var goalTextLabel: UILabel!
    @IBOutlet weak var dailyAvgTextLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var dailyAvgLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationView: UIView!
    @IBOutlet weak var caloriesView: UIView!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var chartView: JBBarChartView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chartContentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var durationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var calorieViewHeight: NSLayoutConstraint!
    @IBOutlet weak var dateViewTop: NSLayoutConstraint!
    @IBOutlet weak var dateViewBottom: NSLayoutConstraint!
    @IBOutlet weak var chartContentViewHeight: NSLayoutConstraint!
    
    var consumedDataArray : [ConsumeClass] = []
    var burnedDataArray : [BurnedClass] = []
    var waterDataArray : [WaterClass] = []
    var weightDataArray : [WeightClass] = []
    
    var duration = DURATION.WEEKLY
    var progress = PROGRESS.CALORIE
    var currentDate = Date()
    
    var dataArray : [ProgressClass] = []
    var numberArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_PROGRESS), object: nil)
        self.previousButton.setImage(UIImage(named: "Arrow_back_health")?.image(withTintColor: UIColor.black), for: UIControl.State.normal)
        self.nextButton.setImage(UIImage(named: "Arrow_front")?.image(withTintColor: UIColor.black), for: UIControl.State.normal)
        self.durationLabel.text = "weekly".toLocalize().capitalized
        self.chartContentView.layer.addCustomShadow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.updateRecord()
    }
    
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Progress".toLocalize())
        if self.duration == .WEEKLY  {
            self.durationLabel.text = "weekly".toLocalize().capitalized
        }
        else if self.duration == .MONTHLY  {
            self.durationLabel.text = "monthly".toLocalize().capitalized
        }
        else {
            self.durationLabel.text = "yearly".toLocalize().capitalized
        }
        if self.progress == .CALORIE {
            self.caloriesLabel.text = "Calorie".toLocalize()
        }
        else if self.progress == .CALORIE_BURED {
            self.caloriesLabel.text = "Calorie_Burned".toLocalize()
        }
        else if self.progress == .WATER {
            self.caloriesLabel.text = "Water".toLocalize()
        }
        else {
            self.caloriesLabel.text = "Weight".toLocalize()
        }
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setMenuBarButton()
        
        if UIScreen.main.nativeBounds.height <= 1136 {
            
            self.durationViewHeight.constant = 30
            self.calorieViewHeight.constant = 30
            self.dateViewTop.constant = 5
            self.dateViewBottom.constant = 5
            self.chartContentViewHeight.constant = 220
        }
        
        self.contentView.layer.addCustomShadow()
        self.durationView.layer.cornerRadius = 5
        self.caloriesView.layer.cornerRadius = 5
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.chartView.delegate = self
        self.chartView.dataSource = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
    }
    
    func updateRecord()  {
        
        self.weightDataArray = WeightClass.getweightArray()
        self.waterDataArray = WaterClass.getWaterArray()
        self.consumedDataArray = ConsumeClass.getConsumeArray()
        self.burnedDataArray = BurnedClass.getBurnedArray()
        
        self.reloadChartData()
        self.updateTopDateLabel()
        
    }
    
    func reloadChartData() {
        
        self.dataArray = []
        let formatter = DateFormatter()
        
        
        if self.duration == .WEEKLY {
            
            for i in (0..<7).reversed() {
                
                if let date = Calendar.current.date(byAdding: .day, value: -i, to: self.currentDate) {
                    
                    let progressObj = ProgressClass()
                    formatter.dateFormat = self.currentDate.isToday() ?  "EEE" : "dd MMM"
                    progressObj.date = date
                    if date.isToday() {
                        progressObj.dateString = "Today".toLocalize()
                    }
                    else {
                        progressObj.dateString = formatter.string(from: date)
                    }

                    formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
                    
                    if self.progress == .CALORIE {
                        
                        let filterArray = self.consumedDataArray.filter { (obj) -> Bool in
                            return obj.date == formatter.string(from: date)
                        }
                        if filterArray.count > 0 {
                            progressObj.value = filterArray[0].servings * filterArray[0].foodObject.calorie
                        }
                    }
                    else if self.progress == .CALORIE_BURED {
                        
                        let filterArray = self.burnedDataArray.filter { (obj) -> Bool in
                            return obj.date == formatter.string(from: date)
                        }
                        if filterArray.count > 0 {
                            progressObj.value = filterArray[0].calories
                        }
                    }
                    else if self.progress == .WATER {
                        
                        let filterArray = self.waterDataArray.filter { (obj) -> Bool in
                            return obj.date == formatter.string(from: date)
                        }
                        if filterArray.count > 0 {
                            
                            var water = filterArray[0].waterValue
                            
                            if UserClass.getSettingWater() == "ml" {
                                water = (water * 29.574)
                            }
                            progressObj.value = water
                        }
                    }
                    else if self.progress == .WEIGHT {
                        
                        let filterArray = self.weightDataArray.filter { (obj) -> Bool in
                            return obj.date == formatter.string(from: date)
                        }
                        if filterArray.count > 0 {

                            var weight = filterArray[0].weight
                            
                            if UserClass.getSettingWeight() == "kg" {
                                if filterArray[0].measurement == "lb" {
                                    weight = weight * 2.205
                                }
                            }
                            else if UserClass.getSettingWeight() == "lb" {
                                if filterArray[0].measurement == "kg" {
                                    weight = weight / 2.205
                                }
                            }
                            progressObj.value = filterArray[0].weight
                        }
                    }
                    
                    self.dataArray.append(progressObj)
                }
            }
        }
        else if self.duration == .MONTHLY {
            
            let monthInDay = self.currentDate.getDaysInMonth()
            
            for i in (0..<monthInDay) {
                
                if let date = Calendar.current.date(byAdding: .day, value: i, to: self.currentDate) {

                    
                    let progressObj = ProgressClass()
                    formatter.dateFormat = "MMM dd"
                    progressObj.date = date
                    progressObj.dateString = formatter.string(from: date)
                    formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
                    
                    if self.progress == .CALORIE {
                        
                        let filterArray = self.consumedDataArray.filter { (obj) -> Bool in
                            return obj.date == formatter.string(from: date)
                        }
                        if filterArray.count > 0 {
                            progressObj.value = filterArray[0].servings * filterArray[0].foodObject.calorie
                        }
                    }
                    else if self.progress == .CALORIE_BURED {
                        
                        let filterArray = self.burnedDataArray.filter { (obj) -> Bool in
                            return obj.date == formatter.string(from: date)
                        }
                        if filterArray.count > 0 {
                            progressObj.value = filterArray[0].calories
                        }
                    }
                    else if self.progress == .WATER {
                        
                        let filterArray = self.waterDataArray.filter { (obj) -> Bool in
                            return obj.date == formatter.string(from: date)
                        }
                        if filterArray.count > 0 {
                            var water = filterArray[0].waterValue
                            
                            if UserClass.getSettingWater() == "ml" {
                                water = (water * 29.574)
                            }
                            progressObj.value = water
                        }


                    }
                    else if self.progress == .WEIGHT {
                        
                        let filterArray = self.weightDataArray.filter { (obj) -> Bool in
                            return obj.date == formatter.string(from: date)
                        }
                        if filterArray.count > 0 {

                            var weight = filterArray[0].weight
                            
                            if UserClass.getSettingWeight() == "kg" {
                                if filterArray[0].measurement == "lb" {
                                    weight = weight * 2.205
                                }
                            }
                            else if UserClass.getSettingWeight() == "lb" {
                                if filterArray[0].measurement == "kg" {
                                    weight = weight / 2.205
                                }
                            }
                            progressObj.value = filterArray[0].weight
                        }
                    }
                    
                    self.dataArray.append(progressObj)
                }
            }
        }
        else if self.duration == .YEARLY {
            
            for i in (0..<12) {
                
                if let date = Calendar.current.date(byAdding: .month, value: i, to: self.currentDate) {

                    let progressObj = ProgressClass()
                    formatter.dateFormat = "MMM"
                    progressObj.date = date
                    progressObj.dateString = formatter.string(from: date)
                    formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
                    
                    if self.progress == .CALORIE {
                        
                        let filterArray = self.consumedDataArray.filter { (obj) -> Bool in
                            
                            if let objectDate = formatter.date(from: obj.date) {
                                
                                let startDate = date.startOfMonth
                                let endDate = date.endOfMonth
                                
                                if objectDate >= startDate && objectDate <= endDate {
                                    return true
                                }
                            }
                            return false
                        }
                        
                        for obj1 in filterArray {
                            progressObj.value += (obj1.servings * obj1.foodObject.calorie)
                        }
                    }
                    else if self.progress == .CALORIE_BURED {
                        
                        let filterArray = self.burnedDataArray.filter { (obj) -> Bool in
                            
                            if let objectDate = formatter.date(from: obj.date) {
                                
                                let startDate = date.startOfMonth
                                let endDate = date.endOfMonth
                                
                                if objectDate >= startDate && objectDate <= endDate {
                                    return true
                                }
                            }
                            return false
                        }
                        
                        for obj1 in filterArray {
                            progressObj.value += (obj1.calories)
                        }
                    }
                    else if self.progress == .WATER {
                        
                        let filterArray = self.waterDataArray.filter { (obj) -> Bool in
                            
                            if let objectDate = formatter.date(from: obj.date) {
                                
                                let startDate = date.startOfMonth
                                let endDate = date.endOfMonth
                                
                                
                                if objectDate >= startDate && objectDate <= endDate {
                                    return true
                                }
                            }
                            return false
                        }
                        
                        for obj1 in filterArray {
                            
                            var water = obj1.waterValue
                            
                            if UserClass.getSettingWater() == "ml" {
                                water = (water * 29.574)
                            }
                            progressObj.value += water
                        }
                    }
                    else if self.progress == .WEIGHT {
                        
                        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
                        let filterArray = self.weightDataArray.filter { (obj) -> Bool in
                            
                            if let objectDate = formatter.date(from: obj.date) {
                                
                                let startDate = date.startOfMonth
                                let endDate = date.endOfMonth
                                
                                
                                if objectDate >= startDate && objectDate <= endDate {
                                    return true
                                }
                            }
                            return false
                        }
                        for obj1 in filterArray {
                            
                            var weight = obj1.weight
                            
                            if UserClass.getSettingWeight() == "kg" {
                                if obj1.measurement == "lb" {
                                    weight = weight * 2.205
                                }
                            }
                            else if UserClass.getSettingWeight() == "lb" {
                                if obj1.measurement == "kg" {
                                    weight = weight / 2.205
                                }
                            }
                            progressObj.value += (weight)
                        }
                    }
                    self.dataArray.append(progressObj)
                }
            }
        }
        
        var maxVal : Float = 0
        for obj2 in self.dataArray {
            
            if obj2.value > maxVal {
                maxVal = obj2.value
            }
        }
        if maxVal == 0 {
            maxVal = 10
        }
        let count : Float = 5
        var inverval : Float = 10
        
        if maxVal >= 500 {
            inverval = 100
        }
        if maxVal <= 10 {
            inverval = 1
        }
        
        let newMaxVal : Float = ((maxVal / Float(count)) / inverval).rounded(FloatingPointRoundingRule.up) * inverval * count
        
        let val = newMaxVal / count

        self.numberArray = []
        for i in 0..<6 {
            let val1 = val.rounded(FloatingPointRoundingRule.up)
            let val2 = round1(val1 * Float(i), toNearest: inverval).toString()
            self.numberArray.append(val2)
        }
        self.numberArray.reverse()
        
        self.chartView.layoutIfNeeded()
        self.chartView.minimumValue = 0
        self.chartView.maximumValue = CGFloat(newMaxVal)
        self.chartView.reloadData(animated: true)
        
        self.collectionView.reloadData()
        self.tableView.reloadData()
        self.updateTopDateLabel()
        self.updateAverage()
        self.updateGoal()
        if self.dataArray.count > 0 {
            self.updateDataLabel(object: self.dataArray[self.dataArray.count - 1])
        }
    }
    
    func round1(_ value: Float, toNearest: Float) -> Float {
        let val1 = (value / toNearest).rounded(FloatingPointRoundingRule.up)
        return val1 * toNearest
    }
    
    func updateDataLabel( object : ProgressClass)  {
        
        let formatter = DateFormatter()
        
        if self.duration == .YEARLY {
            formatter.dateFormat = "MMM yyyy"
            self.todayTextLabel.text = formatter.string(from: object.date)
        }
        else {
            formatter.dateFormat = "dd MMM"
            if object.date.isToday() {
                self.todayTextLabel.text = "Today".toLocalize()
            }
            else {
                self.todayTextLabel.text = formatter.string(from: object.date)
            }
        }
        if self.progress == .CALORIE || self.progress == .CALORIE_BURED {
            self.todayLabel.text = "\(object.value.toString()) cal"
        }
        else if self.progress == .WEIGHT {
            self.todayLabel.text = "\(object.value.toString()) \(UserClass.getSettingWeight())"
        }
        else if self.progress == .WATER {
            self.todayLabel.text = "\(object.value.toString()) \(UserClass.getSettingWater())"
        }
    }
    
    func updateAverage() {
        
        var totalVal : Float = 0
        for obj in self.dataArray {
            totalVal += obj.value
        }
        let avg = totalVal / Float(self.dataArray.count)
        if self.progress == .CALORIE || self.progress == .CALORIE_BURED {
            self.dailyAvgLabel.text = "\(avg.toString()) cal"
        }
        else if self.progress == .WATER {
            self.dailyAvgLabel.text = "\(avg.toString()) \(UserClass.getSettingWater())"
        }
        else if self.progress == .WEIGHT {
            self.dailyAvgLabel.text = "\(avg.toString()) \(UserClass.getSettingWeight())"
        }
    }
    
    func updateGoal() {
        
        if self.progress == .WEIGHT {
            self.goalLabel.text = "\(Global.getConvertedGoalWeight()) \(UserClass.getSettingWeight())"
        }
        else if self.progress == .CALORIE || self.progress == .CALORIE_BURED {
            self.goalLabel.text = "\(UserClass.getGoalCalories().toString()) cal"
        }
        else {
            self.goalLabel.text = ""
        }
    }
    
    func updateTopDateLabel() {
        
        if self.duration == .WEEKLY {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM"
            if let date = Calendar.current.date(byAdding: .day, value: -7, to: self.currentDate) {
                let date1 = formatter.string(from: self.currentDate)
                let date2 = formatter.string(from: date)
                self.dateLabel.text = "\(date2) - \(date1)"
            }
        }
        else if self.duration == .MONTHLY {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            let date1 = formatter.string(from: self.currentDate)
            self.dateLabel.text = "\(date1)"
        }
        else if self.duration == .YEARLY {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let date1 = formatter.string(from: self.currentDate)
            self.dateLabel.text = "\(date1)"
        }
    }
    
    @IBAction func onDurationButtonTap(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: "Duration".toLocalize(), message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "weekly".toLocalize().capitalized, style: UIAlertAction.Style.default, handler: { (action) in
            
            self.duration = .WEEKLY
            self.currentDate = Date()
            self.reloadChartData()
            self.durationLabel.text = "weekly".toLocalize().capitalized
        }))
        actionsheet.addAction(UIAlertAction(title: "monthly".toLocalize().capitalized, style: UIAlertAction.Style.default, handler: { (action) in

            self.duration = .MONTHLY
            self.currentDate = Date()
            self.currentDate = self.currentDate.startOfMonth
            self.reloadChartData()
            self.durationLabel.text = "monthly".toLocalize().capitalized
        }))
        actionsheet.addAction(UIAlertAction(title: "yearly".toLocalize().capitalized, style: UIAlertAction.Style.default, handler: { (action) in

            self.duration = .YEARLY
            self.currentDate = Date()
            self.currentDate = self.currentDate.startOfYear
            self.reloadChartData()
            self.durationLabel.text = "yearly".toLocalize().capitalized
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel".toLocalize(), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    @IBAction func onCaloriesButtonTap(_ sender: Any) {
        
        let actionsheet = UIAlertController(title: "Progress".toLocalize(), message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Calorie".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            
            self.caloriesLabel.text = "Calorie".toLocalize()
            self.progress = .CALORIE
            self.reloadChartData()
        }))
        actionsheet.addAction(UIAlertAction(title: "Calorie_Burned".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in

            self.caloriesLabel.text = "Calorie_Burned".toLocalize()
            self.progress = .CALORIE_BURED
            self.reloadChartData()
        }))
        actionsheet.addAction(UIAlertAction(title: "Water".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in

            self.caloriesLabel.text = "Water".toLocalize()
            self.progress = .WATER
            self.reloadChartData()
        }))
        actionsheet.addAction(UIAlertAction(title: "Weight".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in

            self.caloriesLabel.text = "Weight".toLocalize()
            self.progress = .WEIGHT
            self.reloadChartData()
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel".toLocalize(), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    @IBAction func onNextButtonTap(_ sender: Any) {
        
        if self.duration == .WEEKLY {
            if let date = Calendar.current.date(byAdding: .day, value: 7, to: self.currentDate) {
                
                self.currentDate = date
                self.reloadChartData()
            }
        }
        else if self.duration == .MONTHLY {
            
            if let date = Calendar.current.date(byAdding: .month, value: 1, to: self.currentDate) {
                self.currentDate = date
                self.reloadChartData()
            }
        }
        else if self.duration == .YEARLY {
            
            if let date = Calendar.current.date(byAdding: .year, value: 1, to: self.currentDate) {
                self.currentDate = date
                self.reloadChartData()
            }
        }
    }
    
    @IBAction func onPreviousButtonTap(_ sender: Any) {

        if self.duration == .WEEKLY {
            if let date = Calendar.current.date(byAdding: .day, value: -7, to: self.currentDate) {
                
                self.currentDate = date
                self.reloadChartData()
            }
        }
        else if self.duration == .MONTHLY {
            
            if let date = Calendar.current.date(byAdding: .month, value: -1, to: self.currentDate) {
                self.currentDate = date
                self.reloadChartData()
            }
        }
        else if self.duration == .YEARLY {
            
            if let date = Calendar.current.date(byAdding: .year, value: -1, to: self.currentDate) {
                self.currentDate = date
                self.reloadChartData()
            }
        }
    }
    
    
}
extension ProgressViewController : JBBarChartViewDelegate, JBBarChartViewDataSource {
    
    func numberOfBars(in barChartView: JBBarChartView!) -> UInt {
        return UInt(self.dataArray.count)
    }
    
    func barChartView(_ barChartView: JBBarChartView!, heightForBarViewAt index: UInt) -> CGFloat {
        
        let obj = self.dataArray[Int(index)]
        return CGFloat(obj.value)
    }
    
    func barSelectionColor(for barChartView: JBBarChartView!) -> UIColor! {
        return Color.appGray
    }
    
    func barChartView(_ barChartView: JBBarChartView!, colorForBarViewAt index: UInt) -> UIColor! {
        return Color.appOrange
    }
    
    func barChartView(_ barChartView: JBBarChartView!, didSelectBarAt index: UInt) {
        
    }
    
    func barChartView(_ barChartView: JBBarChartView!, didSelectBarAt index: UInt, touch touchPoint: CGPoint) {
        
        self.updateDataLabel(object: self.dataArray[Int(index)])
    }
    
}
extension ProgressViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.duration == .WEEKLY {
            return self.dataArray.count
        }
        if self.duration == .MONTHLY {
            return 6
        }
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let label = cell.viewWithTag(100) as! UILabel
        if self.duration == .WEEKLY {
            label.textAlignment = .center
            label.text = self.dataArray[indexPath.row].dateString
        }
        else if self.duration == .MONTHLY {
            
            if indexPath.row == 0 {
                label.text = self.dataArray[indexPath.row].dateString
                label.textAlignment = .left
            }
            else if indexPath.row == 5 {
                label.text = self.dataArray[self.dataArray.count - 1].dateString
                label.textAlignment = .right
            }
            else {
                label.textAlignment = .center
                let index = indexPath.row * 6
                if index < self.dataArray.count {
                    label.text = self.dataArray[index].dateString
                }
                else {
                    label.text = ""
                }
            }
        }
        else {
            label.textAlignment = .center
            label.text = self.dataArray[indexPath.row].dateString
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        self.collectionView.layoutIfNeeded()
        
        if self.duration == .WEEKLY {
            let width = (self.collectionView.frame.size.width) / CGFloat(self.dataArray.count)
            let size = CGSize(width: width, height: 30)
            return size
        }
        else if self.duration == .MONTHLY {
            let width = (self.collectionView.frame.size.width) / CGFloat(6)
            let size = CGSize(width: width, height: 30)
            return size
        }
        let width = (self.collectionView.frame.size.width) / CGFloat(self.dataArray.count)
        let size = CGSize(width: width, height: 30)
        return size
    }
}
extension ProgressViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProgressCell
        let label = cell.viewWithTag(100) as! UILabel
        label.text = self.numberArray[indexPath.row]
        let height = self.tableView.frame.size.height / CGFloat(self.numberArray.count)
        
        if indexPath.row == 0 {
            cell.labelBottom.constant = height - 20
            cell.labelTop.constant = 2

        }
        else if indexPath.row == self.numberArray.count - 1 {
            cell.labelBottom.constant = 2
            cell.labelTop.constant = height - 20
        }
        else {
            cell.labelBottom.constant = 2
            cell.labelTop.constant = 2
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        self.tableView.layoutIfNeeded()
        return self.tableView.frame.size.height / CGFloat(self.numberArray.count)
    }
}
