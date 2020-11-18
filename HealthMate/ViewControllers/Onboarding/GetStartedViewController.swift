//
//  GetStartedViewController.swift
//  HealthMate
//
//  Created by AppDeveloper on 22/10/20.
//

import UIKit

class GetStartedViewController: UIViewController {
    
    @IBOutlet weak var logoViewBottom: NSLayoutConstraint!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoViewTop: NSLayoutConstraint!
    @IBOutlet weak var logoViewWidth: NSLayoutConstraint!
    @IBOutlet weak var logoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var signInButton: RoundButton!
    
    var currentPage : Int = 0
    var titleMessageArray : [String] = ["Know_what_in_your_food".toLocalize(), "Counting_Calories_Works".toLocalize(), "Balanced_Macros_Results".toLocalize()]
    var subTitleMessageArray : [String] = ["", "Find_out_how_many_calories".toLocalize(), "Make_sure_you_getting_the_right_balance".toLocalize()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoViewTop.constant = Global.heightRatio * self.logoViewTop.constant
        self.logoViewWidth.constant = Global.heightRatio * self.logoViewWidth.constant
        self.logoViewHeight.constant = Global.heightRatio * self.logoViewHeight.constant
        if UIScreen.main.nativeBounds.height <= 1136 {
            self.logoViewBottom.constant = 10
            self.logoViewTop.constant = 20
        }
        self.initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func initView() {
        
        self.logoView.layoutIfNeeded()
        self.logoView.layer.cornerRadius = self.logoView.frame.size.height / 2
        self.getStartedButton.setTitle("Get_Started".toLocalize(), for: UIControl.State.normal)
        self.signInButton.setTitle("sign_in".toLocalize(), for: UIControl.State.normal)
        self.signInButton.backgroundColor = Color.disableGray
        
        self.navigationController?.isNavigationBarHidden = true
        self.pageControl.currentPage = self.currentPage
        self.pageControl.numberOfPages = 3
        self.pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func onGetStartedButtonTap(_ sender: Any) {
        
        let view = self.storyboard?.instantiateViewController(withIdentifier: "GetStartedTabViewController") as! GetStartedTabViewController
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func onSignInButtonTap(_ sender: Any) {
        
    }
}
extension GetStartedViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let titleLabel = cell.viewWithTag(100) as! UILabel
        let subTitleLabel = cell.viewWithTag(101) as! UILabel
        titleLabel.text = self.titleMessageArray[indexPath.row]
        subTitleLabel.text = self.subTitleMessageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: 152)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.isKind(of: UICollectionView.self) {
            
            if scrollView is UICollectionView {
                
                var visibleRect = CGRect()
                visibleRect.origin = self.collectionView.contentOffset
                visibleRect.size = self.collectionView.bounds.size
                let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
                guard let indexPath = self.collectionView.indexPathForItem(at: visiblePoint) else { return }
                self.currentPage = indexPath.row
                self.pageControl.currentPage = self.currentPage
//                self.collectionView.reloadData()
            }
        }
    }
}
