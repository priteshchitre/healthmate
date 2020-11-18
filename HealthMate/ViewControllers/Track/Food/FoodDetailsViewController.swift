//
//  FoodDetailsViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 28/10/20.
//

import UIKit
import Charts
import ActionSheetPicker_3_0

class FoodDetailsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: RoundButton!
    
    var foodObject : FoodClass = FoodClass()
    var selectedDate = Date()
    var selectedMeal : Int = 0
    var selectedMealString = ""
    var selectedServing : Float = 1
    var val1 : Float = 1
    var val2 : Float = 0
    var val1Index : Int = 1
    var val2Index : Int = 0
    var isFromRecent : Bool = false
    var consumedObject = ConsumeClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshFoodDetails(_:)), name: NSNotification.Name("FoodDetailsRefresh"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_FOOD_DETAILS), object: nil)
        self.initView()
        self.initElements()
    }
    
    @objc func initLocal() {

        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Food_Details".toLocalize())
        self.editButton.setTitle("Edit_Food".toLocalize(), for: UIControl.State.normal)
    }

    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setGrayBackBarButton()
        self.setAteButton()
        
        if self.isFromRecent {
            
        }

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
    }
    
    @objc func refreshFoodDetails(_ notification : Notification) {
        
        if let obj = notification.object as? FoodClass {
            self.foodObject = obj
        }
        self.tableView.reloadData()
    }
    
    func setAteButton() {
        
        let backButton : UIButton = UIButton()
        
        if self.isFromRecent {
            backButton.setTitle("Update".toLocalize(), for: UIControl.State.normal)
        }
        else {
            backButton.setTitle("I_Ate_This".toLocalize(), for: UIControl.State.normal)
        }

        backButton.setTitleColor(Color.appOrange, for: UIControl.State.normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        backButton.addTarget(self, action: #selector(self.onAteButtonTap), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.sizeToFit()
        backButton.titleLabel?.textAlignment = .right
        backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = backBarButton
    }
    
    @objc func onAteButtonTap() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
        
        if !self.isFromRecent {
            let timestamp = NSDate().timeIntervalSince1970
            self.consumedObject.consumeId = "\(timestamp)"
        }
        else {
            if self.consumedObject.date != formatter.string(from: self.selectedDate) {
                let timestamp = NSDate().timeIntervalSince1970
                self.consumedObject.consumeId = "\(timestamp)"
            }
        }

        self.consumedObject.date = formatter.string(from: self.selectedDate)
        self.consumedObject.mealType = self.selectedMeal
        self.consumedObject.servings = self.selectedServing
        
        ConsumeClass.updateRecord(self.consumedObject, foodObject: self.foodObject)
        if self.isFromRecent {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onEditButtonTap(_ sender: Any) {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "CustomFoodViewController") as! CustomFoodViewController
        view.foodObject = self.foodObject
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        if let entry1 = entry as? PieChartDataEntry {
            if let chartView1 = chartView as? PieChartView {
                chartView1.centerText = "\(entry1.label!)\n\(Int(entry1.value)) "
            }
        }
    }
    
    func setDataCount(_ chartView : PieChartView) {
        
        let totalGram = self.foodObject.fat + self.foodObject.carb + self.foodObject.protein
        
        let fatPer = self.foodObject.fat * 100 / totalGram
        let carbPer = self.foodObject.carb * 100 / totalGram
        let proteinPer = self.foodObject.protein * 100 / totalGram
        
        let entry1 = PieChartDataEntry(value: Double(fatPer), label: "")
        let entry2 = PieChartDataEntry(value: Double(carbPer), label: "")
        let entry3 = PieChartDataEntry(value: Double(proteinPer), label: "")
        
        let set = PieChartDataSet(entries: [entry1, entry2, entry3], label: "")
        
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = [UIColor(hexString: "#FED76A"),
                      UIColor(hexString: "#A1B0E8"),
                      UIColor(hexString: "#64E482")]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        pFormatter.maximumFractionDigits = 0
        pFormatter.multiplier = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 15, weight: .medium))
        data.setValueTextColor(.clear)
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        chartView.drawEntryLabelsEnabled = false // Label hide / show
        chartView.usePercentValuesEnabled = false
        
        chartView.drawCenterTextEnabled = false
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "")
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = false
    }
}
extension FoodDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as! FoodDetailsCell
            cell.bgView.layer.addCustomShadow()
            cell.titleLabel.text = self.foodObject.foodName
            cell.sizeLabel.text = "\("Serving_Size".toLocalize()): \(self.foodObject.servingType)"
            return cell
        }
        if indexPath.section == 1 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "ServingCell", for: indexPath) as! FoodDetailsCell
            cell.bgView.layer.addCustomShadow()
            
            if indexPath.row == 0 {
                cell.titleLabel.text = "Servings".toLocalize()
                cell.servingLabel.text = self.selectedServing.toString()
            }
            else if indexPath.row == 1 {
                
                cell.titleLabel.text = "Date".toLocalize()
                let formatter = DateFormatter()
                formatter.dateFormat = "MMM dd yyyy"
                let today = formatter.string(from: Date())
                let selectedDate = formatter.string(from: self.selectedDate)
                if today == selectedDate {
                    cell.servingLabel.text = "Today".toLocalize()
                }
                else {
                    formatter.dateFormat = "MMM dd"
                    cell.servingLabel.text = formatter.string(from: self.selectedDate)
                }
            }
            else {
                cell.titleLabel.text = "Meal".toLocalize()
                cell.servingLabel.text = self.selectedMealString
            }
            return cell
        }
        if self.foodObject.fat == 0 && self.foodObject.carb == 0 && self.foodObject.protein == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "CalorieCell", for: indexPath) as! FoodDetailsCell
            cell.bgView.layer.addCustomShadow()
            let totalCalories = self.selectedServing * self.foodObject.calorie
            cell.totalCalories.text = "\(totalCalories.toString()) \("Total_Calories".toLocalize())"
            return cell
        }

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! FoodDetailsCell
        
        cell.bgView.layer.addCustomShadow()
        cell.dot1View.layer.cornerRadius = cell.dot1View.frame.size.height / 2
        cell.dot2View.layer.cornerRadius = cell.dot1View.frame.size.height / 2
        cell.dot3View.layer.cornerRadius = cell.dot1View.frame.size.height / 2
        
        self.setup(pieChartView: cell.chartView)
        cell.chartView.delegate = self
        
        // entry label styling
        cell.chartView.entryLabelColor = .white
        cell.chartView.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        self.setDataCount(cell.chartView)
        
        cell.chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        
        let totalGram = self.foodObject.fat + self.foodObject.carb + self.foodObject.protein
        let fatPer = self.foodObject.fat * 100 / totalGram
        let carbPer = self.foodObject.carb * 100 / totalGram
        let proteinPer = self.foodObject.protein * 100 / totalGram
        cell.fatLabel.text = "\("Fat".toLocalize()) : \(self.foodObject.fat.toString()) g /\(fatPer.toString())%"
        cell.carbLabel.text = "\("Carb".toLocalize()) : \(self.foodObject.carb.toString()) g /\(carbPer.toString())%"
        cell.proteinLabel.text = "\("Protein".toLocalize()) : \(self.foodObject.protein.toString()) g /\(proteinPer.toString())%"

        let totalCalories = self.selectedServing * self.foodObject.calorie
        cell.totalCalories.text = "\(totalCalories.toString()) \("Total_Calories".toLocalize())"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let picker = ActionSheetCustomPicker(title: "Serving".toLocalize(), delegate: self, showCancelButton: true, origin: self.view, initialSelections: [self.val1Index,self.val2Index,0])
                picker?.show()
            }
            else if indexPath.row == 1 {
                
                let datePicker = ActionSheetDatePicker(title: "Date".toLocalize(), datePickerMode: UIDatePicker.Mode.date, selectedDate: self.selectedDate, doneBlock: { (picker, value, index) in
                        
                    if let date = value as? Date {
                        self.selectedDate = date
                    }
                    self.tableView.reloadData()
                }, cancel: { (picker) in
                    
                }, origin: self.view)
                datePicker?.show()
            }
            else {
                
                let mealArray : [String] = ["Breakfast".toLocalize(), "Lunch".toLocalize(), "Dinner".toLocalize(), "Snack".toLocalize()]
                
                let picker = ActionSheetStringPicker(title: "Meal".toLocalize(), rows: mealArray, initialSelection: 0, doneBlock: { (picker, index, value) in
                    
                    self.selectedMealString = AnyObjectRef(value as AnyObject).stringValue()
                    self.selectedMeal = index
                    self.tableView.reloadData()
                }, cancel: { (picker) in
                    
                }, origin: self.view)
                picker?.show()
            }
        }
    }
}
extension FoodDetailsViewController : ActionSheetCustomPickerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return 101
        }
        if component == 1 {
            return 100
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return "\(row)"
        }
        if component == 1 {
            let str = String(format: "%.2f", Float(Float(row)/100))
            return str
        }
        return self.foodObject.servingType
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            self.val1 = Float(row)
            self.val1Index = row
        }
        if component == 1 {
            self.val2 = Float(Float(row)/100)
            self.val2Index = row
        }
        self.selectedServing = self.val1 + self.val2
        self.tableView.reloadData()
    }
    
    
}
