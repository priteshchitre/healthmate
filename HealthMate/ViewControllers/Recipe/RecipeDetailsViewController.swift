//
//  RecipeDetailsViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 29/10/20.
//

import UIKit
import Charts
import SDWebImage
import ActionSheetPicker_3_0

class RecipeDetailsViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var object = RecipeClass()
    var val1Index : Int = 1
    var val2Index : Int = 0
    var selectedServing : Float = 1
    var val1 : Float = 1
    var val2 : Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initView()
        self.initElements()
        NotificationCenter.default.addObserver(self, selector: #selector(self.initLocal), name: NSNotification.Name(Constants.LOCAL_RECIPE_DETAILS), object: nil)
    }
    
    @objc func initLocal() {
        
        self.setNavigationTitle(navigationItem: self.navigationItem, title: "Recipe_Details".toLocalize())
        self.tableView.reloadData()
    }
    
    func initView() {
        
        self.initLocal()
        self.setNavigationBar()
        self.setGrayBackBarButton()
        self.setAteButton()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func initElements() {
        
    }
    
    func setAteButton() {
        
        let backButton : UIButton = UIButton()
        
        backButton.setTitle("I_Ate_This".toLocalize(), for: UIControl.State.normal)

        backButton.setTitleColor(Color.appOrange, for: UIControl.State.normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 90, height: 30)
        backButton.addTarget(self, action: #selector(self.onAteButtonTap), for: UIControl.Event.touchUpInside)
        backButton.contentMode = .scaleAspectFit
        backButton.titleLabel?.font = UIFont.customFont(name: Font.RobotoMedium, size: 18)
        backButton.sizeToFit()
        backButton.titleLabel?.textAlignment = .right
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.rightBarButtonItem = backBarButton
    }
    
    @objc func onAteButtonTap() {
        
        let picker = ActionSheetCustomPicker(title: "Serving".toLocalize(), delegate: self, showCancelButton: true, origin: self.view, initialSelections: [self.val1Index,self.val2Index])
        picker?.show()
    }
    
    func openMealSelection() {
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Breakfast".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            
            self.updateFood(0)
        }))
        actionSheet.addAction(UIAlertAction(title: "Lunch".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            self.updateFood(1)
        }))
        actionSheet.addAction(UIAlertAction(title: "Dinner".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            self.updateFood(2)
        }))
        actionSheet.addAction(UIAlertAction(title: "Snack".toLocalize(), style: UIAlertAction.Style.default, handler: { (action) in
            self.updateFood(3)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel".toLocalize(), style: UIAlertAction.Style.cancel, handler: { (action) in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func updateFood(_ mealType : Int) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.CONSUMED_DATE_FORMATE
        
        let foodObject = FoodClass()
        let timestamp = NSDate().timeIntervalSince1970
        foodObject.foodId = "\(timestamp)"
        foodObject.foodName = self.object.title
        foodObject.servingType = ""
        foodObject.carb = self.object.carbs
        foodObject.fat = self.object.fat
        foodObject.protein = self.object.protein
        foodObject.calorie = self.object.calorie * self.selectedServing

        let consumedObject = ConsumeClass()
        consumedObject.consumeId = "\(timestamp)"

        consumedObject.date = formatter.string(from: Date())
        consumedObject.mealType = mealType
        consumedObject.servings = self.selectedServing
        
        ConsumeClass.updateRecord(consumedObject, foodObject: foodObject)
        Global.showSuccess("\(foodObject.calorie.toString()) \("Calories_added".toLocalize())")
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        if let entry1 = entry as? PieChartDataEntry {
            if let chartView1 = chartView as? PieChartView {
                chartView1.centerText = "\(entry1.label!)\n\(Int(entry1.value)) "
            }
        }
    }
    
    func setDataCount(_ chartView : PieChartView) {
        
        let totalGram = self.object.fat + self.object.carbs + self.object.protein
        
        let fatPer = self.object.fat * 100 / totalGram
        let carbPer = self.object.carbs * 100 / totalGram
        let proteinPer = self.object.protein * 100 / totalGram
        
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
extension RecipeDetailsViewController : UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }
        if section == 2 {
            return 1 + self.object.ingredientArray.count
        }
        if section == 3 {
            return 1 + self.object.directionsArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeListCell
            cell.recipeTitleLabel.text = object.title
            cell.recipeImageView.sd_setImage(with: URL(string: object.image)!, placeholderImage: UIImage(named: "recipePlaceholder"), options: SDWebImageOptions.continueInBackground, context: nil)
//            cell.seringLabel.text = "\(object.calorie.toString()) cal/\("servings".toLocalize()), \("serve".toLocalize()) \(object.serve)"
            cell.seringLabel.text = ""
            return cell
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! RecipeListCell
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
                
                let totalGram = self.object.fat + self.object.carbs + self.object.protein
                
                let fatPer = self.object.fat * 100 / totalGram
                let carbPer = self.object.carbs * 100 / totalGram
                let proteinPer = self.object.protein * 100 / totalGram
                
                cell.totalCaloriesLabel.text = "\(self.object.calorie.toString()) \("Calories_per_Serving".toLocalize())"
                cell.subTitleLabel.text = "\("Serving_Size".toLocalize()) : \(object.servingSize)"
                
                cell.fatLabel.text = "\("Fat".toLocalize()) : \(self.object.fat.toString())g / \(fatPer.toString())%"
                cell.carbLabel.text = "\("Carb".toLocalize()) : \(self.object.carbs.toString())g / \(carbPer.toString())%"
                cell.proteinLabel.text = "\("Protein".toLocalize()) : \(self.object.protein.toString())g / \(proteinPer.toString())%"
                return cell
            }
            
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TimeCell", for: indexPath) as! RecipeListCell
            cell.timeImageView.maskWith(color: Color.appGray)
            
            
            cell.preperationLabel.text = "\("PREP".toLocalize())\n\(self.object.preperationTime) m"
            let attributedString: NSMutableAttributedString = cell.preperationLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
            let longString = cell.preperationLabel.text! as NSString
            let matchRange = (longString as NSString).range(of: "\(self.object.preperationTime) m")
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: matchRange)
            cell.preperationLabel.attributedText = attributedString
            

            cell.cookLabel.text = "\("COOK".toLocalize())\n\(self.object.cookTime) m"
            let attributedString1: NSMutableAttributedString = cell.cookLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
            let longString1 = cell.cookLabel.text! as NSString
            let matchRange1 = (longString1 as NSString).range(of: "\(self.object.cookTime) m")
            attributedString1.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: matchRange1)
            cell.cookLabel.attributedText = attributedString1

            cell.totalLabel.text = "\("TOTAL".toLocalize())\n\(self.object.totalTime) m"
            let attributedString2: NSMutableAttributedString = cell.totalLabel.attributedText!.mutableCopy() as! NSMutableAttributedString
            let longString2 = cell.totalLabel.text! as NSString
            let matchRange2 = (longString2 as NSString).range(of: "\(self.object.totalTime) m")
            attributedString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: matchRange2)
            cell.totalLabel.attributedText = attributedString2
            
            cell.seringLabel.text = "\(object.serve) \("servings".toLocalize())".uppercased()
            cell.recipeDetailLabel.text = self.object.recipeDescription
            return cell
        }
        if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! RecipeListCell
                cell.titleLabel.text = "Ingredients".toLocalize()
                return cell
            }
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! RecipeListCell
            cell.titleLabel.text = self.object.ingredientArray[indexPath.row - 1].title
            cell.dotView.layer.cornerRadius = cell.dotView.frame.size.height / 2
            return cell
        }
        
        if indexPath.row == 0 {
            
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! RecipeListCell
            cell.titleLabel.text = "Directions".toLocalize()
            return cell
        }
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "DirectionCell", for: indexPath) as! RecipeListCell
        cell.titleLabel.text = self.object.directionsArray[indexPath.row - 1]
        cell.numberLabel.text = "\(indexPath.row)"
        return cell
    }
}
extension RecipeDetailsViewController : ActionSheetCustomPickerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        2
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
        return self.object.servingSize
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
    }
    func actionSheetPickerDidSucceed(_ actionSheetPicker: AbstractActionSheetPicker!, origin: Any!) {
        
        self.openMealSelection()
    }
}
